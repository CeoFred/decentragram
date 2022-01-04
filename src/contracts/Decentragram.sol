pragma solidity ^0.5.0;

contract Decentragram {
  string public name = "Decentragram";


  // Store Posts
  uint public imageCount = 0;
  mapping(uint => Image) public images;

  struct Image {
  uint id;
  string hash;
  string description;
  uint tipAmount;
  address payable author;
} 

event ImageCreated(
  uint id,
  string hash,
  string description,
  uint tipAmount,
  address payable author
);

event ImageTipped(
  uint id,
  string hash,
  string description,
  uint tipAmount,
  address payable author
);


function uploadImage(string memory _imgHash, string memory _description) public {
  
  require(bytes(_imgHash).length > 0, 'Image imgHash is required');
  require(bytes(_description).length > 0, 'Image description is required');
  require(msg.sender != address(0x0),'Fake ass address');

  imageCount++;

  // Add Image to contract
  images[imageCount] = Image(imageCount, _imgHash,  _description, 0, msg.sender);

  // Trigger an event
  emit ImageCreated(imageCount, _imgHash, _description, 0, msg.sender);
}
  // Create Images

  function tipImageOwner(uint _id) public payable {
    // Make sure that the id is valid
    require(_id > 0 && _id <= imageCount);
    // Fetch the image
    Image memory _image = images[_id];

    address payable _author = _image.author;

    address(_author).transfer(msg.value);

    _image.tipAmount = _image.tipAmount + msg.value;

    images[_id] = _image;
    
    emit ImageTipped(_id, _image.hash, _image.description, _image.tipAmount, _author);

  }
 

}