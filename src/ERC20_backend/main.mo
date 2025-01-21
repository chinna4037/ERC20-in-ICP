import ERC20 "./ERC";
import Principal "mo:base/Principal";
actor CoffeeToken {
  var x=ERC20.ERC20("Coffee Tokens","CFF",null,Principal.fromText("annqt-l6vpa-2ncf7-2noxp-rlxjf-oxdjd-jsae6-ccjzh-dyjkd-k2s6z-gae"));

  public query func name():async Text{
      x.name()
  };    
   
  public query func symbols(): async Text{
     x.symbols()
  };  

  public query func totalSupply():async Nat{
     x.totalSupply()
  };

  public shared query (msg) func balance():async Nat{
    x.balanceOf(msg.caller)
  };

  public shared (msg) func transfer(to:Principal,amount:Nat):async Bool{
    assert(x.transfer(msg.caller,to,amount));
    true
  };

  public shared query (msg) func allowance(spender:Principal):async Nat{
    x.allowance(msg.caller,spender)
  };

  public shared (msg) func approve(spender:Principal,value:Nat):async Bool{
    assert x.approve(msg.caller,spender,value);
    true
  };

  public shared (msg) func transferFrom(from:Principal, to:Principal, value:Nat):async Bool{
    assert x.transferFrom(msg.caller,from,to,value);
    true
  };

};
