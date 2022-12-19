import smartpy as sp

tstorage = sp.TRecord(myParameter1 = sp.TIntOrNat, myParameter2 = sp.TIntOrNat).layout(("myParameter1", "myParameter2"))
tparameter = sp.TVariant(myEntryPoint = sp.TIntOrNat).layout("myEntryPoint")
tprivates = { }
tviews = { }
