// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract StudentDetails{
    // The beginning of my contact
    // Creating a structure for Student Details

    struct Student{
        uint classNumber;
        string Name;
        uint Age;
    }


    uint public studentCount;
    Student[] internal register;

    event infochanged(uint _classNumber, string _Name, uint _Age, string _whatHappened);


    function addStudent(string memory _Name, uint _Age) public {
        //this will insert a studen's detail into the array
        register.push(Student(studentCount, _Name, _Age));

        emit infochanged(studentCount, _Name, _Age, "We just added a student");
        studentCount++;
    }

    function getStudentByClassNumber(uint _classNumber) public view returns(Student memory) {
        
        return register[_classNumber];
       
    }

   /* function getAllStudents() public returns(Student[] memory) {
        register.pop();
        return register;
    }
    */
}