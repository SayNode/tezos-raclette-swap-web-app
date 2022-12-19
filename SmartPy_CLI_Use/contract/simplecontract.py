import smartpy as sp

class Certification(sp.Contract):
    def __init__(self, certifier):
        self.init(certified=sp.map(tkey=sp.TAddress, tvalue=sp.TString), certifier=certifier.address)

    @sp.entry_point
    def certify(self, params):
        sp.verify(sp.sender==self.data.certifier)
        self.data.certified[params.address]= params.name

@sp.add_test(name = "Certify")
def test():
    anil = sp.test_account("Anil")
    ibo = sp.test_account("Ibo")
    
    contract= Certification(certifier=anil)
    scenario = sp.test_scenario()

    scenario+= contract
    
    scenario+= contract.certify(name= anil.seed, address= anil.address).run(sender=anil)
    scenario+= contract.certify(name= ibo.seed, address= ibo.address).run(sender=anil)