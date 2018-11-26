pragma solidity^0.4.25;

contract PickAColor {
    enum Colors { Black, Red, White, Blue, Green }
    Colors color;
    Colors constant defaultColor = Colors.Black;
    
    function pickAColor(uint _x) public {
        require (_x > 0 && _x < 6);
        if (_x == 1) color = Colors.Black;
        if (_x == 2) color = Colors.Red;
        if (_x == 3) color = Colors.White;
        if (_x == 4) color = Colors.Blue;
        if (_x == 5) color = Colors.Green;
    }
    
    function getColor() public view returns (Colors) {
        return color;
    }
    
    function getDefaultColor() public pure returns (Colors) {
        return defaultColor;
    }
}
