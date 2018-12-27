pragma solidity ^0.4.24;

contract ERC20Interface{
    
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function transfer(address to, uint tokens) public returns (bool success);
    
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
    
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval (address indexed tokenOwner,address indexed spender,uint tokens);
}

contract AJTokens is ERC20Interface{
    
    string public name = "AJTokens";
    string public symbol ="AJ";
    uint public decimals = 0;
    uint public supply;
    address public founder;
    
    
    constructor() public {
        founder = msg.sender;
        supply = 20000000;
        balances[founder]= supply;
    }
    
    mapping(address => uint) balances;
    mapping (address => mapping(address => uint)) allowed;
    //allowed[from][to]=100;
    
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval (address indexed tokenOwner,address indexed spender,uint tokens);
    
    function allowance(address tokenOwner, address spender) public view returns (uint remaining){
        return allowed[tokenOwner][spender];
    }
    
    function approve(address spender, uint tokens) public returns (bool success){
        require(balances[msg.sender] >= tokens && tokens > 0);
        allowed[msg.sender][spender]= tokens;
        emit Approval(msg.sender,spender,tokens);
        return true;
    }
    
    function transferFrom(address from, address to, uint tokens) public returns (bool success){
        
        require(allowed[from][to] >= tokens);
        require(balances[from] >= tokens);
        balances[to] += tokens;
        balances[from] -= tokens;
        allowed[from][to] -= tokens;
        return true;
    }
    
    function totalSupply() public view returns (uint){
        return supply;
    }
    
    function balanceOf(address tokenOwner) public view returns (uint balance){
        return balances[tokenOwner];
    }
    
    function transfer(address to, uint tokens) public returns (bool success){
        require (balances[msg.sender] >= tokens && tokens > 0);
        balances[to] += tokens;
        balances[msg.sender] -= tokens;
        emit Transfer(msg.sender,to,tokens);
        return true;
    }
}




//how to test this ICO 

//"0xE7Cc733E717D5878401618D65d1Dc54ECCdD027E"  -- first acc
//"0xBd95f0Eac88a7C4B6A7654C9bB719f9b7fC7B570"	-- second acc
//"0x89458cEa44b7e0185C1f075149E6b688bAc9E4c2" -- Third Acc
//0x1764A6Db57362C4D02fc37DF19240ecaeBee52B4 -- contract address

//make third account as deposit account(parameter in the constructor)
//post that, we will get an contract address
// add token by importing the contract address(click on add button)
// initially token balance will be zero.
//transfer 1 ETH to contract address, you will get 1000 AJTokens
// And deposit address will be credited by 1 ETH
// token account will be dedcuted and to will be added with tokens and will reflect in metamask
