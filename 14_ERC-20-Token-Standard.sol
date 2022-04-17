// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function name() external view returns (string memory nameToken);

    function symbol() external view returns (string memory symbolToken);

    function decimals() external view returns (uint8 decimalsToken);

    function totalSupply() external view returns (uint256 totalSupplyToken);

    function balanceOf(address owner) external view returns (uint256 balance);

    function transfer(address to, uint256 value)
        external
        returns (bool success);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool success);

    function approve(address spender, uint256 value)
        external
        returns (bool success);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256 remaining);
}

// abstract เป้นนามธรรม ต้องเอาไป extend ต่อถึงใช้งานได้
abstract contract ERC20 is
    IERC20 // is เสมือนการ implement interface ของ class
{
    string _name; // global อยู่ตลอด
    string _symbol;
    uint256 _totalSupply;
    mapping(address => uint256) _balances;
    mapping(address => mapping(address => uint256)) _allowances; // owner => spender => uint

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view override returns (string memory nameToken) {
        // override เพื่อเขียนfunctionทับเข้าไปใน interface
        return _name;
    }

    function symbol() public view override returns (string memory symbolToken) {
        return _symbol;
    }

    function decimals() public pure override returns (uint8 decimalsToken) {
        return 0;
    }

    function totalSupply()
        public
        view
        override
        returns (uint256 totalSupplyToken)
    {
        return _totalSupply;
    }

    function balanceOf(address owner)
        public
        view
        override
        returns (uint256 balance)
    {
        return _balances[owner];
    }

    function transfer(address to, uint256 value)
        public
        override
        returns (bool success)
    {
        _transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value)
        public
        override
        returns (bool success)
    {
        _approve(msg.sender, spender, value);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        override
        returns (uint256 remaining)
    {
        return _allowances[owner][spender];
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public override returns (bool success) {
        if (from != msg.sender) {
            require(
                value >= _allowances[from][msg.sender],
                "transfer amount not enough"
            );
            _approve(from, msg.sender, _allowances[from][msg.sender] - value);
        }

        _transfer(from, to, value);
        return true;
    }

    //==Private Function ======
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal {
        // internal คือ private ของ abstract contract
        require(amount > 0, "amount must more 0");
        require(from != address(0), "transfer from zero address");
        require(to != address(0), "transfer to zero address");
        require(amount < _balances[from], "balance not enough");

        _balances[from] -= amount;
        _balances[to] += amount;

        emit Transfer(from, to, amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        require(amount <= _balances[owner], "token not enough");
        require(owner != address(0), "owner zero address");
        require(spender != address(0), "spender zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _mint(address to, uint256 amount) internal {
        require(to != address(0), "mint to zero");

        _balances[to] += amount;
        _totalSupply += amount;

        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal {
        require(from != address(0), "transfer from zero address");
        require(amount <= _balances[from], "token not enough");

        _balances[from] -= amount;
        _totalSupply -= amount;

        emit Transfer(from, address(0), amount);
    }
}

contract BPC is ERC20 {
    constructor() ERC20("Bird Pang Coin", "BPC") {}

    function deposit() public payable {
        require(msg.value > 0, "amount is zero");

        _mint(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public payable {
        require(amount <= _balances[msg.sender], "Token not enough"); // เข้าถึง global variable คลาสแม่ได้ contract แม่

        payable(msg.sender).transfer(amount);
        _burn(msg.sender, amount);
    }
}
