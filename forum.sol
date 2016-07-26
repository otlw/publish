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

  event PostMade
  ( address _postAddress);

  function Forum(string forumName, uint cost)
  {
    name = forumName;
    replyCost = cost;
  }

  function makePost(string title, string data)
  {
    Document newPost = new Document(data);
    titles[address(newPost)] = title;
    timeStamp[address(newPost)] = now;
    PostMade(address(newPost));
  }

  function addTag(address post, string tagToAdd)
  {
    tag[tagToAdd].push(post);
    postTags[post].push(tagToAdd);
  }

  function makeReply(string title, string data, address replyTo, uint weight)
  {
    if(msg.value >= replyCost)
    {
      if(replyTo.send(msg.value) == false)
      {
        throw;
      }
      address reply = makePost(title, data);
      replies[replyTo].push(reply);
      Document(reply).addSource(replyTo, weight);
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

  function getNumberOfTags(address post) constant returns(uint)
  {
    return postTags[post].length;
  }
}
