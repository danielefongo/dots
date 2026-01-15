{ lib, ... }:

let
  mkCheck =
    testName: checkName: predicate: errorMsg:
    let
      fullName = "${testName} -> ${checkName}";
      result = predicate { };
    in
    if result then
      builtins.trace " ${fullName}" true
    else
      builtins.trace " ${fullName}\n${errorMsg}" false;

  checkEq =
    testName: checkName: actual: expected:
    mkCheck testName checkName (
      _: actual == expected
    ) "  Expected: ${builtins.toJSON expected}\n  Got:      ${builtins.toJSON actual}";

  checkNotNull =
    testName: checkName: actual:
    mkCheck testName checkName (_: actual != null) "  Expected: not null\n  Got:      null";

  checkIsNull =
    testName: checkName: actual:
    mkCheck testName checkName (
      _: actual == null
    ) "  Expected: null\n  Got:      ${builtins.toJSON actual}";

  checkTrue =
    testName: checkName: actual:
    mkCheck testName checkName (
      _: actual == true
    ) "  Expected: true\n  Got:      ${builtins.toJSON actual}";

  checkFalse =
    testName: checkName: actual:
    mkCheck testName checkName (
      _: actual == false
    ) "  Expected: false\n  Got:      ${builtins.toJSON actual}";

  checkHasAttr =
    testName: checkName: attrName: attrSet:
    mkCheck testName checkName (_: attrSet ? ${attrName})
      "  Expected: attribute '${attrName}' to exist\n  Got:      ${builtins.toJSON (builtins.attrNames attrSet)}";

  mkHelpers = testName: {
    eq = checkEq testName;
    true = checkTrue testName;
    false = checkFalse testName;
    isNull = checkIsNull testName;
    notNull = checkNotNull testName;
    hasAttr = checkHasAttr testName;
  };

  mkTest =
    testName: arg:
    let
      helpers = mkHelpers testName;
      context = arg.context or { };
      checksFn = arg.checks or (_: _: [ ]);
    in
    {
      name = testName;
      inherit context;
      checksFn = checksFn;
      checks = checksFn helpers context;
    };
in
{
  test = mkTest;

  group =
    groupName: tests:
    map (
      testDef:
      mkTest "${groupName} -> ${testDef.name}" {
        inherit (testDef) context checksFn;
        checks = testDef.checksFn;
      }
    ) tests;

  runTests =
    tests:
    let
      flattenTests =
        list: lib.concatMap (item: if builtins.isList item then flattenTests item else [ item ]) list;
      allTests = flattenTests tests;
      allChecks = lib.concatLists (map (test: test.checks) allTests);
      allPassed = lib.all (x: x == true) allChecks;
    in
    if allPassed then true else throw "Some tests failed. Check the trace output above.";
}
