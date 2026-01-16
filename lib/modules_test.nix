{
  pkgs ? import <nixpkgs> { },
}:

let
  lib = pkgs.lib;
  modules = import ../lib/modules.nix { inherit pkgs; };
  tests = import ../lib/tests.nix { inherit lib; };

  simulateConfig =
    config:
    lib.evalModules {
      modules = [
        {
          options.output = lib.mkOption {
            type = lib.types.attrs;
            default = { };
          };
          options.home = lib.mkOption {
            type = lib.types.attrs;
            default = { };
          };
        }
        config
      ];
    };
in
{
  result = tests.runTests [
    (tests.group "optional" [
      (tests.test "enabled home package" {
        context = simulateConfig {
          imports = [
            (modules.optionalHomePkg "mod.hello" pkgs.hello)
          ];

          module.mod.hello.enable = true;
        };
        checks = t: context: [
          (t.eq "package is included" context.config.home.packages [ pkgs.hello ])
        ];
      })

      (tests.test "disabled home package" {
        context = simulateConfig {
          imports = [
            (modules.optionalHomePkg "mod.hello" pkgs.hello)
          ];

          module.mod.hello.enable = false;
        };
        checks = t: context: [
          (t.eq "package is not included" context.config.home { })
        ];
      })

      (tests.test "module creates a config" {
        context = simulateConfig {
          imports = [
            (modules.optionalModule "mod" {
              value = {
                type = lib.types.int;
                default = 42;
              };
              value2 = {
                type = lib.types.str;
              };
            } (cfg: { }))
          ];

          module.mod.value2 = "custom value";
        };
        checks = t: context: [
          (t.hasAttr "has module option" "mod" context.options.module)
          (t.eq "default value is 42" context.config.module.mod {
            enable = null;
            value = 42;
            value2 = "custom value";
          })
        ];
      })

      (tests.test "nested module creates a config" {
        context = simulateConfig {
          imports = [
            (modules.optionalModule "parent.child" {
              value = {
                type = lib.types.int;
                default = 42;
              };
            } (cfg: { }))
          ];
        };
        checks = t: context: [
          (t.hasAttr "has module option" "child" context.options.module.parent)
          (t.eq "default value is 42" context.config.module.parent.child {
            enable = null;
            value = 42;
          })
        ];
      })

      (tests.test "enabled module sets output" {
        context = simulateConfig {
          imports = [
            (modules.optionalModule "mod"
              {
                count = {
                  type = lib.types.int;
                  default = 10;
                };
                name = {
                  type = lib.types.str;
                };
              }
              (cfg: {
                output.value = "${cfg.name}-${toString cfg.count}";
              })
            )
          ];

          module.mod = {
            enable = true;
            name = "foo";
          };
        };
        checks = t: context: [
          (t.eq "is enabled" context.config.module.mod.enable true)
          (t.eq "output is set" context.config.output {
            value = "foo-10";
          })
        ];
      })

      (tests.test "disabled module does not set output" {
        context = simulateConfig {
          imports = [
            (modules.optionalModule "mod" { } (cfg: {
              output.shouldNotExist = "This should not be set if module is disabled";
            }))
          ];
          module.mod.enable = false;
        };
        checks = t: context: [
          (t.eq "is not enabled" context.config.module.mod.enable false)
          (t.eq "output is not set" context.config.output { })
        ];
      })

      (tests.test "disabled module by default" {
        context = simulateConfig {
          imports = [
            (modules.optionalModule "mod" { } (cfg: {
              output.shouldNotExist = "This should not be set if module is disabled";
            }))
          ];
        };
        checks = t: context: [
          (t.isNull "enable is not defined" context.config.module.mod.enable)
          (t.eq "output is not set" context.config.output { })
        ];
      })

      (tests.test "nested module enabled by parent" {
        context = simulateConfig {
          imports = [
            (modules.optionalModule "parent" { } (cfg: { }))
            (modules.optionalModule "parent.child" { } (cfg: {
              output.val = 42;
            }))
          ];

          module.parent.enable = true;
        };
        checks = t: context: [
          (t.eq "output is set" context.config.output {
            val = 42;
          })
        ];
      })

      (tests.test "nested module disabled by parent" {
        context = simulateConfig {
          imports = [
            (modules.optionalModule "parent" { } (cfg: { }))
            (modules.optionalModule "parent.child" { } (cfg: {
              output.shouldNotExist = "This should not be set if parent is disabled";
            }))
          ];

          module.parent.enable = false;
          module.parent.child.enable = true;
        };
        checks = t: context: [
          (t.eq "output is not set" context.config.output { })
        ];
      })

      (tests.test "parent module can disable child module" {
        context = simulateConfig {
          imports = [
            (modules.optionalModule "mod"
              {
                disable_child = {
                  type = lib.types.bool;
                  default = false;
                };
              }
              (cfg: {
                module.mod.child.enable = !cfg.disable_child;
              })
            )
            (modules.optionalModule "mod.child" { } (cfg: {
              output.xxx = true;
            }))
          ];

          module.mod = {
            enable = true;
            disable_child = true;
          };
        };
        checks = t: context: [
          (t.eq "output is not set" context.config.output { })
        ];
      })

      (tests.test "parent module can force disable child with mkForce" {
        context = simulateConfig {
          imports = [
            (modules.optionalModule "parent"
              {
                disable_child = {
                  type = lib.types.bool;
                  default = false;
                };
              }
              (cfg: {
                module.parent.child.enable = lib.mkForce (!cfg.disable_child);
              })
            )
            (modules.optionalModule "parent.child" { } (cfg: {
              output.child = true;
            }))
          ];

          module.parent = {
            enable = true;
            disable_child = true;
          };
          module.parent.child.enable = true;
        };
        checks = t: context: [
          (t.eq "child is force disabled" context.config.module.parent.child.enable false)
          (t.eq "output is not set" context.config.output { })
        ];
      })

      (tests.test "module enables another module" {
        context = simulateConfig {
          imports = [
            (modules.optionalModule "mod1" { } (cfg: {
              module.mod2.enable = true;
              output.mod1 = true;
            }))
            (modules.optionalModule "mod2" { } (cfg: {
              output.mod2 = true;
            }))
          ];

          module.mod1.enable = true;
        };
        checks = t: context: [
          (t.eq "mod1 is enabled" context.config.module.mod1.enable true)
          (t.eq "mod2 is enabled" context.config.module.mod2.enable true)
          (t.eq "both outputs are set" context.config.output {
            mod1 = true;
            mod2 = true;
          })
        ];
      })

      (tests.test "module with nested imports" {
        context = simulateConfig {
          imports = [
            (modules.optionalModule "parent" { } (cfg: {
              imports = [
                (modules.optionalModule "parent.child" { } (cfg: {
                  output.child = "from child";
                }))
              ];
              output.parent = "from parent";
            }))
          ];

          module.parent.enable = true;
        };
        checks = t: context: [
          (t.eq "parent is enabled" context.config.module.parent.enable true)
          (t.isNull "child inherits null enable" context.config.module.parent.child.enable)
          (t.eq "both outputs are set" context.config.output {
            parent = "from parent";
            child = "from child";
          })
        ];
      })

      (tests.test "bundle enables all children" {
        context = simulateConfig {
          imports = [
            (modules.optionalBundle "bundle" [
              "mod1"
              "mod2"
              "mod3"
            ])
            (modules.optionalModule "mod1" { } (cfg: {
              output.mod1 = true;
            }))
            (modules.optionalModule "mod2" { } (cfg: {
              output.mod2 = true;
            }))
            (modules.optionalModule "mod3" { } (cfg: {
              output.mod3 = true;
            }))
          ];

          module.bundle.enable = true;
        };
        checks = t: context: [
          (t.eq "bundle is enabled" context.config.module.bundle.enable true)
          (t.eq "mod1 is enabled" context.config.module.mod1.enable true)
          (t.eq "mod2 is enabled" context.config.module.mod2.enable true)
          (t.eq "mod3 is enabled" context.config.module.mod3.enable true)
          (t.eq "all outputs are set" context.config.output {
            mod1 = true;
            mod2 = true;
            mod3 = true;
          })
        ];
      })

      (tests.test "bundle disabled overrides enabled children" {
        context = simulateConfig {
          imports = [
            (modules.optionalBundle "bundle" [
              "mod1"
              "mod2"
            ])
            (modules.optionalModule "mod1" { } (cfg: {
              output.mod1 = true;
            }))
            (modules.optionalModule "mod2" { } (cfg: {
              output.mod2 = true;
            }))
          ];

          module.bundle.enable = false;
          module.mod1.enable = true;
          module.mod2.enable = true;
        };
        checks = t: context: [
          (t.eq "bundle is disabled" context.config.module.bundle.enable false)
          (t.eq "mod1 is disabled" context.config.module.mod1.enable false)
          (t.eq "mod2 is disabled" context.config.module.mod2.enable false)
          (t.eq "no output is set" context.config.output { })
        ];
      })

      (tests.test "parent disabled overrides bundle enabled" {
        context = simulateConfig {
          imports = [
            (modules.optionalModule "parent" { } (cfg: { }))
            (modules.optionalBundle "parent.bundle" [
              "parent.mod1"
              "parent.mod2"
            ])
            (modules.optionalModule "parent.mod1" { } (cfg: {
              output.mod1 = true;
            }))
            (modules.optionalModule "parent.mod2" { } (cfg: {
              output.mod2 = true;
            }))
          ];

          module.parent.enable = false;
          module.parent.bundle.enable = true;
        };
        checks = t: context: [
          (t.eq "parent is disabled" context.config.module.parent.enable false)
          (t.eq "bundle is enabled" context.config.module.parent.bundle.enable true)
          (t.eq "no output is set" context.config.output { })
        ];
      })
    ])

    (tests.group "withCfg" [
      (tests.test "module" {
        context = simulateConfig {
          imports = [
            (modules.withCfg "mod.inner"
              {
                value = {
                  type = lib.types.int;
                };
              }
              (cfg: {
                output.result = cfg.value;
              })
            )
          ];

          cfg.mod.inner.value = 42;
        };
        checks = t: context: [
          (t.eq "output is set correctly" context.config.output.result 42)
        ];
      })
    ])
  ];
}
