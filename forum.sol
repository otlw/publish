import "document.sol";

contract Forum
{
  string name;
  uint replyCost;
  mapping (address => string) titles;
  mapping (address => uint) timeStamp;
  mapping (string => address[]) tag;
  mapping (address => address[]) replies;
  mapping (address => string[]) postTags;
  mapping (address => address[]) postsByAuthor;

  event PostMade
  ( address _postAddress);

  function Forum(string forumName, uint cost)
  {
    name = forumName;
    replyCost = cost;
  }

  function getReplyCost() returns(uint)
  {
    return replyCost;
  }

  function makePost(string title, string data)
  {
    address[] memory authors = new address[] (2);
    authors[0] = msg.sender;
    authors[1] = address(this);
    uint[] memory weights = new uint[] (2);
    weights[0] = 75;
    weights[1] = 0;
    Document newPost = new Document(data, authors, weights);
    titles[address(newPost)] = title;
    timeStamp[address(newPost)] = now;
    postsByAuthor[msg.sender].push(address(newPost));
    PostMade(address(newPost));
  }

  function addTag(address post, string tagToAdd)
  {
    tag[tagToAdd].push(post);
    postTags[post].push(tagToAdd);
  }

  function makeReply(string title, string data, address replyTo)
  {
    if(msg.value >= replyCost)
    {
      if(replyTo.send(msg.value) == false)
      {
        throw;
      }
      address[] memory authors = new address[] (2);
      authors[0] = msg.sender;
      authors[1] = address(this);
      uint[] memory weights = new uint[] (2);
      weights[0] = 75;
      weights[1] = 0;
      Document newPost = new Document(data, authors, weights);
      titles[address(newPost)] = title;
      timeStamp[address(newPost)] = now;
      postsByAuthor[msg.sender].push(address(newPost));
      PostMade(address(newPost));
      replies[replyTo].push(address(newPost));
      Document(address(newPost)).addSource(replyTo, 25);
    }
  }

  function getTitle(address post) constant returns(string)
  {
    return titles[post];
  }

  function getReplies(address post) constant returns(address[])
  {
    return replies[post];
  }

  function getPostsFromTag(string tagName) constant returns(address[])
  {
    return tag[tagName];
  }

  function getTagFromPosts(address post, uint i) constant returns(string)
  {
    return postTags[post][i];
  }

  function getPostsFromAuthos(address author) constant returns(address[])
  {
    return postsByAuthor[author];
  }

  function getNumberOfTags(address post) constant returns(uint)
  {
    return postTags[post].length;
  }
}
