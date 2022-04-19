// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface ERC721 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function balanceOf(address owner) external view returns (uint256);
    function ownerOf(uint256 tokenId) external view returns (address);
    function setApprovalForAll(address operator, bool approved) external;
    function isApprovedForAll(address owner, address operator) external view returns (bool);
    function approve(address approved, uint256 tokenId) external payable;
    function getApproved(uint256 tokenId) external view returns (address);
    function transferFrom(address from, address to, uint256 tokenId) external payable;
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) external payable;
    function safeTransferFrom(address from, address to, uint256 tokenId) external payable;
}

interface ERC165 {
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}

interface ERC721TokenReceiver {
    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes memory _data) external returns(bytes4);
}

interface ERC721Metadata /* is ERC721 */ {
    function name() external view returns (string memory name);
    function symbol() external view returns (string memory symbol);
    function tokenURI(uint256 _tokenId) external view returns (string memory);
}

interface ERC1155Metadata_URI {
    function uri(uint256 tokenId) external view returns (string memory);
}

interface ERC721Enumerable /* is ERC721 */ {
    function totalSupply() external view returns (uint256);
    function tokenByIndex(uint256 _index) external view returns (uint256);
    function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
}

abstract contract IERC721 is ERC165, ERC721, ERC721Metadata, ERC1155Metadata_URI, ERC721Enumerable {
    // map ประหยัดค่า gas ที่สุด ประหยัดกว่า array
    mapping(address => uint) _balances; // owner => balance
    mapping(uint => address) _owners; // tokenId => owner
    mapping(address => mapping(address => bool)) _operatorApprovals; // owner => operator => approv
    mapping(uint => address) _tokenApprovals; // tokenId => operator

    string _name;
    string _symbol;
    mapping(uint => string) _tokenURIs; // token => uri

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }


    function supportsInterface(bytes4 interfaceID) public override pure returns (bool) {
        return interfaceID == type(ERC165).interfaceId 
            || interfaceID == type(ERC721).interfaceId
            || interfaceID == type(ERC721Metadata).interfaceId
            || interfaceID == type(ERC1155Metadata_URI).interfaceId
            || interfaceID == type(ERC721Enumerable).interfaceId;
    }

    function balanceOf(address owner) public override view returns (uint256) {
        require(owner != address(0), "address is zero");
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public override view returns (address) {
        address owner = _owners[tokenId]; // ถ้าไม่เจอ toeknId จะ return address(0)
        require(owner != address(0), "address is zero");
        return owner;
    }

    function setApprovalForAll(address operator, bool approved) public override {
        require(operator != address(0), "oprator is address zero");
        require(msg.sender != operator, "you addsign your self");

        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(address owner, address operator) public override view returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function approve(address approved, uint256 tokenId) public override payable {
        address owner = ownerOf(tokenId);
        require(approved != owner, "approve for self");
        require(msg.sender == owner || isApprovedForAll(owner, msg.sender), "caller is not token owner");

        _approve(approved, tokenId);
    }

    function getApproved(uint256 tokenId) public override view returns (address) {
        require(_owners[tokenId] != address(0), "token is not exits");

        return _tokenApprovals[tokenId];
    }

    function transferFrom(address from, address to, uint256 tokenId) public override payable {
        require(from != address(0) && to != address(0), "address zero");
        require(_balances[from] >= 1, "not enough");
        require(ownerOf(tokenId) == from, "you not owner");
        require(msg.sender == ownerOf(tokenId) 
        || msg.sender == getApproved(tokenId) 
        || isApprovedForAll(ownerOf(tokenId), msg.sender)
        , "caller is not owner or approval");


        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);

        _removeTokenFromOwnerEnumelation(from, tokenId);
        _addTokenToOwnerEnumeration(to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override payable {
        transferFrom(from, to, tokenId);

        require(_checkOnErc721Received(from, to, tokenId, data), "transfer to non ERC721RECEIVER implementer");
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public override payable {
        safeTransferFrom(from, to, tokenId, "");
    }

    function name() public override view returns (string memory) {
        return _name;
    }

    function symbol() public override view returns (string memory) {
        return _symbol;
    }

    function tokenURI(uint256 _tokenId) public override view returns (string memory) {
        return _tokenURIs[_tokenId];
    }

    function uri(uint256 tokenId) public override view returns (string memory) {
        return tokenURI(tokenId);
    }

    function totalSupply() public override view returns (uint256) {
        return _allTokens.length;
    }

    function tokenByIndex(uint256 index) public override view returns (uint256) {
        require(index < _allTokens.length, "index out of bought");

        return _allTokens[index];
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) public override view returns (uint256) {
        require(index < _balances[owner], "index out of bounds");
        return _ownedTokens[owner][index];
    }

    //=== Private or internal Function =======
    
    function _approve(address to, uint tokenId) internal {
        _tokenApprovals[tokenId] = to;
        address owner = ownerOf(tokenId);
        emit Approval(owner, to, tokenId);
    }

    function _checkOnErc721Received(address from, address to, uint tokenId, bytes memory data) internal returns (bool) {
        if (to.code.length <= 0) return true; // แสดงว่าเป็น address คน

        ERC721TokenReceiver receiver = ERC721TokenReceiver(to);
        try receiver.onERC721Received(msg.sender, from, tokenId, data) returns(bytes4 interfaceId) {
            return interfaceId == type(ERC721TokenReceiver).interfaceId;
        } catch Error(string memory reason) {
            revert(reason);
        } catch {
            revert("tranfer to non ERC721Receiver implementer");
        }
    } 

    function _mint(address to, uint tokenId, string memory uri_) internal {
        require(to != address(0), "mint to zero address");
        require(_owners[tokenId] == address(0), "token already minted");

        _balances[to] += 1;
        _owners[tokenId] = to;
        _tokenURIs[tokenId] = uri_;

        emit Transfer(address(0), to, tokenId);

        _addTokenToAllEnumelation(tokenId);
        _addTokenToOwnerEnumeration(to, tokenId);
    }

    function _safeMint(address to, uint tokenId, string memory uri_, bytes memory data) internal {
        _mint(to, tokenId, uri_);

        require(_checkOnErc721Received(address(0), to, tokenId, data), "mint to non Erc721Received");
    }

    function _safeMint(address to, uint tokenId, string memory uri_) internal {
        _safeMint(to, tokenId, uri_, "");
    }

    function _burn(uint tokenId) internal {
        address owner = ownerOf(tokenId);
        require(msg.sender == owner 
        || msg.sender == getApproved(tokenId) 
        || isApprovedForAll(owner, msg.sender)
        , "caller is not owner or approv");

        _approve(address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];
        delete _tokenURIs[tokenId];

        emit Transfer(owner, address(0), tokenId);

        _removeTokenFromAllEnumelation(tokenId);
        _removeTokenFromOwnerEnumelation(owner, tokenId);
    }

     // All Enumelation 
    uint[] _allTokens; 
    mapping(uint => uint) _allTokensIndex; // tokenId => index

    // All Enumelation
    function _addTokenToAllEnumelation(uint tokenId) private {
        _allTokens.push(tokenId);
        _allTokensIndex[tokenId] = _allTokens.length - 1;
    }

    function _removeTokenFromAllEnumelation(uint tokenId) private {
        uint index = _allTokensIndex[tokenId];
        uint indexLast = _allTokens.length - 1;

        if (index < indexLast) {
            uint tokenIdLast = _allTokensIndex[indexLast];
            _allTokens[index] = tokenIdLast;
            _allTokensIndex[tokenIdLast] = index;
        }

        _allTokens.pop();
        delete _allTokensIndex[tokenId];
    }
    // Owner Enumelation
    mapping(address => mapping(uint => uint)) _ownedTokens; // owner => (index => tokenId)
    mapping(uint => uint) _ownedTokensIndex; // tokenId => index    
    // Owner Enumelation

    function _addTokenToOwnerEnumeration(address owner, uint tokenId) private {
        uint index = _balances[owner] - 1;
        _ownedTokens[owner][index] = tokenId;
        _ownedTokensIndex[tokenId] = index;
    }

    function _removeTokenFromOwnerEnumelation(address owner, uint tokenId) private {
        uint index = _ownedTokensIndex[tokenId];
        uint indexLast = _balances[owner];

        if (index < indexLast) {
            uint idLast = _ownedTokens[owner][indexLast];

            _ownedTokens[owner][index] = idLast;
            _ownedTokensIndex[idLast] = index;
        }

        delete _ownedTokens[owner][indexLast];
        delete _ownedTokensIndex[tokenId];
    }
}


contract INFT is IERC721 {
    constructor() IERC721("INF Collectibles", "INFI") {

    }

    function create(uint tokenId, string memory uri) public {
        _mint(msg.sender,  tokenId, uri);
    }

    function burn(uint tokenId) public {
        _burn(tokenId);
    }
}