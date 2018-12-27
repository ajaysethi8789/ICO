pragma solidity ^0.4.24;
import "./ERC20Tranxit.sol";

contract AJICO is AJTokens{
    
    address public admin;
    address public deposit;
    
    //unit token price i ether = 1000 AJ Tokens , 1 token = 0.001 ETH
    uint tokenPrice = 1000000000000000;
    
    //hardCap in Weis(totalCapital wanting to receive)
    uint public hardCap=300000000000000000000;
    uint public raisedAmount;
    uint public salesStart= now;
    // now = block.timestamp
    
    uint public salesEnd = now + 604800;
    uint public coinTradeStart = salesEnd + 604800 ; // transferreable in a week after sales seconds
    
    uint public maxInvestment = 5000000000000000000;
    uint public minInvestment = 1000000000000000;
    
    enum State {beforeStart, running, afterEnd, halted}
    State public icoState;
    
    modifier onlyAdmin(){
        require(msg.sender ==  admin);
        _;
    }
    
    constructor (address _deposit){
        deposit = _deposit;
        admin = msg.sender;
        icoState = State.beforeStart;
    }
    
    //emergency stop
    function halt() public onlyAdmin{
        icoState = State.halted;
    }
    
    //restart 
    function restart() public onlyAdmin{
        icoState = State.running;
    }
    
    //change the deposit function if something goes wrong
    function changeDepositAddress(address newDepositAddress) onlyAdmin{
        deposit = newDepositAddress;
    }
    
    //getCurrentState of the icoState
    function getCurrentState() public view returns (State){
        if(icoState == State.halted) {
            return State.halted;
        }
        else if(block.timestamp < salesStart){
            return State.beforeStart;
        }
        else if (block.timestamp >= salesStart && block.timestamp <= salesEnd){
            return State.running;
        }
        else{
            return State.afterEnd;
        }
    }
    event BuyTokens(address investor, uint value, uint tokens);
    event SellTokens(address seller, address buyer, uint tokens);
    
    
    function buyTokens() public payable returns (bool){
        icoState = getCurrentState();
        require (icoState == State.running);
        require (msg.value >= minInvestment && msg.value <= maxInvestment);
        
        
        uint tokens = msg.value / tokenPrice;
        
        //hardCap not reached.
        require (raisedAmount + msg.value <= hardCap);
        
        raisedAmount += msg.value;
        balances[msg.sender] += tokens;
        balances[founder] -= tokens;
        
        deposit.transfer(msg.value);
        emit BuyTokens(msg.sender,msg.value,tokens);
        return true;
        
    }
    
    function () public payable{
        buyTokens();
    }
    
    function sellTokens(address seller, address buyer, uint tokens) public payable returns (bool){
        
        icoState = getCurrentState();
        require (icoState == State.running);
        require (msg.value >= minInvestment && msg.value <= maxInvestment);
        balances[seller] -= tokens;
        balances[buyer] += tokens;
        uint EtherTransferred= tokens * tokenPrice;
        seller.transfer(EtherTransferred);
        SellTokens(seller,buyer,tokens);
        
    }
    
    //token should be transferreable once sale ends and till after 1 week only.
     function transfer(address to,uint value) public returns(bool){
        require(block.timestamp >= coinTradeStart);
        super.transfer(to,value);
    }
    
    //token should be transferreable once sale ends and till after 1 week only.
     function transferFrom(address from,address to,uint value) public returns(bool){
        require(block.timestamp >= coinTradeStart);
        super.transferFrom(from,to,value);
    }
    
    //unsold tokens should be destroyed or burnt
    function burn() public{
        icoState=getCurrentState();
        require(icoState == State.afterEnd);
        balances[founder] = 0;
    }
    
    
}

