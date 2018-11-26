pragma solidity^0.4.25;

contract Quiz {
   
   // Assumes code will not be looked at by participants
   // Very long method - Answers are hard-coded
   
   address owner;
    
    string yes;
    string no;
    string questions;
    uint points;
    uint waityourturn;
    uint question;
    address player;

    
       constructor() public {
       owner = msg.sender;
       points = 0;
       waityourturn = 0;
       question = 1;
   } 
    
    function registerQuiz(string _yes, string _no, string _questions) public {
        require (msg.sender == owner);
        yes = _yes;
        no = _no;
        questions = _questions;
    }
    
    function getQuestions() public view returns (string) {
        return (questions);
    }
    
    function registerToPlay() public {
        require (waityourturn == 0);
        player = msg.sender;
        waityourturn++;
    }
    
    function questionOne(string _answer) public {
           require (msg.sender == player);
           require (question == 1);
           require(stringsEqual(yes, _answer) == true ||
           stringsEqual(no, _answer));
           if (stringsEqual(yes, _answer) == true) points++;
           question++;
        }
    
        function questionTwo(string _answer) public {
           require (msg.sender == player);
           require (question == 2);
           require(stringsEqual(yes, _answer) == true ||
           stringsEqual(no, _answer));
           if (stringsEqual(no, _answer) == true) points++;
           question++;

     }
        function questionThree(string _answer) public {
        require (msg.sender == player);
        require (question == 3);
        require(stringsEqual(yes, _answer) == true ||
        stringsEqual(no, _answer));
        if (stringsEqual(no, _answer) == true) points++;
        question++;

        }
        function questionFour(string _answer) public {
        require (msg.sender == player);
        require (question == 4);
        require(stringsEqual(yes, _answer) == true ||
        stringsEqual(no, _answer));
        if (stringsEqual(yes, _answer) == true) points++;
        question++;
     }
    
       function questionFive(string _answer) public {
        require (msg.sender == player);
        require (question == 5);
        require(stringsEqual(yes, _answer) == true ||
        stringsEqual(no, _answer));
        if (stringsEqual(yes, _answer) == true) points++;
        question++;

        }
    
       function questionSix(string _answer) public {
          require (msg.sender == player);
          require (question == 6);
          require(stringsEqual(yes, _answer) == true ||
          stringsEqual(no, _answer));
          if (stringsEqual(yes, _answer) == true) points++;
          question++;
         }
    
       function questionSeven(string _answer) public {
         require (msg.sender == player);
         require (question == 7);
         require(stringsEqual(yes, _answer) == true ||
         stringsEqual(no, _answer));
         if (stringsEqual(yes, _answer) == true) points++;
         question++;

        }
    
       function questionEight(string _answer) public {
         require (msg.sender == player);
         require (question == 8);
         require(stringsEqual(yes, _answer) == true ||
         stringsEqual(no, _answer));
         if (stringsEqual(no, _answer) == true) points++;
          question++;

         }
       function questionNine(string _answer) public {
         require (msg.sender == player);
         require (question == 9);
         require(stringsEqual(yes, _answer) == true ||
         stringsEqual(no, _answer));
         if (stringsEqual(yes, _answer) == true) points++;
         question++;
     }
    
       function questionTen(string _answer) public {
        require (msg.sender == player);
        require (question == 10);
        require(stringsEqual(yes, _answer) == true ||
        stringsEqual(no, _answer));
        if (stringsEqual(no, _answer) == true) points++;
        question++;
        }
    
    function getResults() public view returns (string){
        if (points >= 6) return "You win";
        else return "You lose";
    }
    
    function resetQuiz() public {
        require(msg.sender == owner);
        points = 0;
        waityourturn = 0;
        question = 1;
        player = 0;
    }
    
            function stringsEqual(string storage _a, string memory _b) internal pure returns(bool) {
        bytes storage a = bytes(_a);
        bytes memory b = bytes(_b);

        // Compare two strings using SHA3
        if (keccak256(a) != keccak256(b)) {
            return false;
        }
        return true;
    }
}

