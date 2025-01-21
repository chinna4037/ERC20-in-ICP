import Principal "mo:base/Principal";
import HashMap "mo:base/HashMap";
module {
    public type approvalType=HashMap.HashMap<Principal,Nat>;
    public class ERC20(_name:Text,_symbol:Text,supply:?Nat,caller:Principal){
        let _totalSupply:Nat=switch(supply){
            case (null) 100_000_000;
            case (?supply) supply;
        };
        private var balances:HashMap.HashMap<Principal,Nat> = HashMap.HashMap<Principal, Nat>(0, Principal.equal, Principal.hash);
        private var allowances: HashMap.HashMap<Principal,approvalType> =HashMap.HashMap<Principal,approvalType>(0, Principal.equal, Principal.hash);
        

        balances.put(caller,_totalSupply);

        public  func name():Text{
           _name
        };

        public func symbols():Text{
            _symbol
        };

        public func totalSupply():Nat{
            _totalSupply
        };

        public func balanceOf(account:Principal):Nat{
            let x=balances.get(account);
            switch x{
                case null 0;
                case (?x) x;
            };
        } ;

        public func transfer(from:Principal,to:Principal,amount:Nat):Bool{
            assert from!=to;
            let senderBalance:Nat=balanceOf(from);
            assert (senderBalance>=amount);
            let receiverBalance:Nat=balanceOf(to);
            balances.put(from,senderBalance-amount);
            balances.put(to,receiverBalance+amount);
            true;
        };

        private func mappingOfUser(owner:Principal):approvalType{
            let x: ?approvalType=allowances.get(owner);
            switch x{
                case null {
                    let newMap:approvalType=HashMap.HashMap<Principal, Nat>(0, Principal.equal, Principal.hash);
                    allowances.put(owner,newMap);
                    newMap
                };
                case (?x) x;
            };
        };

        public func allowance(owner:Principal, spender:Principal):Nat {
            assert (owner!=spender);
            let mappingOfSender:approvalType=mappingOfUser(owner);
            let result: ?Nat = mappingOfSender.get(spender);
            switch result{
                case null 0;
                case (?result) result;
            };
        };

        public func approve(owner:Principal,spender:Principal,value:Nat):Bool{
            assert (owner!=spender);
            let mappingOfSender:approvalType= mappingOfUser(owner);
            if (mappingOfSender.get(spender) != ?value){
                mappingOfSender.put(spender,value);
                allowances.put(owner,mappingOfSender);
            };
            true
        };

        public func transferFrom(caller:Principal,from : Principal ,to:Principal,value:Nat):Bool{
            assert(from!=to);
            assert(value!=0);
            let approvalAmount:Nat=allowance(from,caller);
            assert (approvalAmount>=value);
            assert transfer(from,to,value);
            assert approve(from,caller,(approvalAmount-value));
            true
        }
        
    }
}