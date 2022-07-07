import macros

macro combine*(newName: untyped, enumA, enumB: typed): untyped =
  ## Combines two enums, the newly generated enum has the pragma `pure`
  result = newStmtList()
  var typeSection = newNimNode(nnkTypeSection)
  var typeDef = newNimNode(nnkTypeDef)
  var pragmaExpr = newNimNode(nnkPragmaExpr)
  pragmaExpr.add ident($newName)
  pragmaExpr.add newNimNode(nnkPragma).add(ident("pure"))
  typeDef.add pragmaExpr
  typeDef.add newEmptyNode()
  var enumTy = newNimNode(nnkEnumTy, newEmptyNode())
  enumTy.add newEmptyNode()
  for idn in enumA.getImpl[2][1 .. ^1]:
    enumTy.add idn
  for idn in enumB.getImpl[2][1 .. ^1]:
    enumTy.add idn
  typeDef.add enumTy
  typeSection.add typeDef
  result.add typeSection
  echo repr result

when isMainModule:


  # dumpTree:
  #   type
  #     partialEnum0 = enum
  #         test0
  #         test1

  #     partialEnum1 = enum
  #         test2
  #         test3


  type
    partialEnum0 = enum
        test0 = 0
        test1 = 1

    partialEnum1 = enum
        test2 = 2
        test3 = 3

  combine(A, partialEnum0, partialEnum1)

  let x = A.test0
  let y = A.test2