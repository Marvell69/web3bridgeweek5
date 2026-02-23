// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./Snow.sol";

// School Contract

contract School {

    Snow public paymentToken;

    mapping(uint256 => uint256) public studentLevel;
    mapping(address=> bool) public hasRegistered;

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

    struct Student {        `,,
        uint256 id;
        string name;
        uint256 level;
    }

    struct Staff {
        uint256 id;
        string name;
        address account;
        bool suspended;
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
            account: _account,
            suspended: false
        }));
    }
    function suspendStaff(uint256 _id) external onlyOwner {
        for (uint256 i = 0; i < staffs.length; i++) {
            if (staffs[i].id == _id) {
                staffs[i].suspended = true;
                return;
            }
        }
    }
    function reinstateStaff(uint256 _id) external onlyOwner {
        for (uint256 i = 0; i < staffs.length; i++) {
            if (staffs[i].id == _id) {
                staffs[i].suspended = false;
                return;
            }
        }
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
function removeStudent(uint256 _id) external onlyOwner {
        for (uint256 i = 0; i < students.length; i++) {
            if (students[i].id == _id) {
                students[i] = students[students.length - 1];
                students.pop();
                return;
            }
        }
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