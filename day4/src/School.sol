// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Snow Token

contract Snow {
    string public name = "Snow";
    string public symbol = "SNW";
    uint8 public decimals = 18;

    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);

    function transfer(address to, uint256 amount) public returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");

        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;

        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(balanceOf[from] >= amount, "Insufficient balance");
        require(allowance[from][msg.sender] >= amount, "Allowance exceeded");

        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;

        emit Transfer(from, to, amount);
        return true;
    }

    function mint(uint256 amount) public {
        balanceOf[msg.sender] += amount;
        totalSupply += amount;

        emit Transfer(address(0), msg.sender, amount);
    }
}

// School Contract

contract School {

    Snow public paymentToken;

    mapping(uint256 => uint256) public studentLevel;

    uint256 private constant SALARY = 6000e18;

    address public owner;

    constructor(address _tokenAddress) {
        studentLevel[100] = 1000e18;
        studentLevel[200] = 3000e18;
        studentLevel[300] = 3500e18;
        studentLevel[400] = 4000e18;

        paymentToken = Snow(_tokenAddress);
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    struct Student {
        uint256 id;
        string name;
        uint256 level;
    }

    struct Staff {
        uint256 id;
        string name;
        address account;
    }

    Student[] public students;
    Staff[] public staffs;

    uint256 private staff_id;
    uint256 private student_id;

    function addStaff(string memory _name, address _account) external onlyOwner {
        require(_account != address(0), "Invalid account");

        staff_id++;
        staffs.push(Staff({
            id: staff_id,
            name: _name,
            account: _account
        }));
    }

    function payStaff(uint256 _id) external onlyOwner {
        address staffAccount;

        for (uint256 i = 0; i < staffs.length; i++) {
            if (staffs[i].id == _id) {
                staffAccount = staffs[i].account;
                break;
            }
        }

        require(staffAccount != address(0), "Staff not found");
        require(paymentToken.balanceOf(address(this)) >= SALARY, "Insufficient fund");

        bool success = paymentToken.transfer(staffAccount, SALARY);
        require(success, "Payment failed");
    }

    function getAllStaff() external view returns (Staff[] memory) {
        return staffs;
    }

    function registerStudent(string memory _name, uint256 _level) external {

        require(
            _level == 100 ||
            _level == 200 ||
            _level == 300 ||
            _level == 400,
            "Invalid level"
        );

        uint256 fee = studentLevel[_level];
        require(fee > 0, "Fee not set");

        bool success = paymentToken.transferFrom(msg.sender, address(this), fee);
        require(success, "Fee payment failed");

        student_id++;
        students.push(Student({
            id: student_id,
            name: _name,
            level: _level
        }));
    }

    function getStudent(uint256 _id) external view returns (Student memory) {
        for (uint256 i = 0; i < students.length; i++) {
            if (students[i].id == _id) {
                return students[i];
            }
        }
        revert("Student not found");
    }

    function getAllStudents() external view returns (Student[] memory) {
        return students;
    }
}