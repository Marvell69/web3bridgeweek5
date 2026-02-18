// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

contract Todo{
  struct Task{
   uint8 id;
   string title;
   bool isComplete;
   uint256 timeCompleted;
   }
  Task[] public tasks;
    uint8 todo_id;

  function createTask(string memory _title) external{
  todo_id = todo_id + 1;
  // Task memory task = Task(id, _title, false, 0);
  Task memory task = Task({id: todo_id, title: title, isComplete: false, timeCompleted: 0});
  task.push(task);

    }

  function getAllTasks() external view returns (Task[] memory)
   {
    return tasks;
   }

  fucntion markComplete(uint8 _id) external {
  for (uint8 i; i < tasks.length; i++){
    if (tasks[i].id == _id){
      tasks[i].isComplete = true;
      tasks[i].timeCompleted = block.timestamp;
    }
  }
   }
   function deleteTask(uint8 _id) external {
    for (uint8 i; i< tasks.length; i++){
      if (tasks[i].id == _id) {
        tasks[i] = tasks[tasks.length -1];
        tasks.pop();
      }
    }
   }
 function updateTask(uint8 _id, string memory _newTitle) external {
    for (uint8 i = 0; i < tasks.length; i++) {
        if (tasks[i].id == _id) {
            tasks[i].title = _newTitle;
          
        }
    }
}
 }