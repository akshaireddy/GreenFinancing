// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GreenFinancing {
    // Structure to represent a green project
    struct Project {
        address creator;  // Address of the project creator
        string name;      // Name of the project
        uint256 goal;     // Funding goal in ether
        uint256 currentFunding;  // Current funding received
        uint256 deadline; // Funding deadline in UNIX timestamp
        bool isFunded;    // Whether the project is fully funded
        bool isClosed;    // Whether the project is closed
    }

    // Mapping to store project details
    mapping(uint256 => Project) public projects;
    uint256 public projectCounter;

    // Event to notify when a new project is created
    event ProjectCreated(uint256 projectId, address creator, string name, uint256 goal, uint256 deadline);

    // Function to create a new project
    function createProject(string memory _name, uint256 _goal, uint256 _deadline) external {
        require(_goal > 0, "Goal must be greater than 0");
        require(_deadline > block.timestamp, "Deadline must be in the future");

        uint256 projectId = projectCounter;
        projects[projectId] = Project({
            creator: msg.sender,
            name: _name,
            goal: _goal,
            currentFunding: 0,
            deadline: _deadline,
            isFunded: false,
            isClosed: false
        });

        emit ProjectCreated(projectId, msg.sender, _name, _goal, _deadline);

        projectCounter++;
    }

    // Function to contribute funds to a project
    function contribute(uint256 _projectId) external payable {
        Project storage project = projects[_projectId];
        require(!project.isClosed, "Project is closed");
        require(block.timestamp < project.deadline, "Funding deadline has passed");
        require(!project.isFunded, "Project is already funded");
        require(msg.value > 0, "Contribution must be greater than 0");

        project.currentFunding += msg.value;

        if (project.currentFunding >= project.goal) {
            project.isFunded = true;
        }
    }

    // Function to close a project and withdraw funds
    function closeProject(uint256 _projectId) external {
        Project storage project = projects[_projectId];
        require(!project.isClosed, "Project is already closed");
        require(msg.sender == project.creator, "Only the creator can close the project");

        if (project.isFunded) {
            payable(project.creator).transfer(project.currentFunding);
        }

        project.isClosed = true;
    }
}
