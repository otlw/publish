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

  function forum(string forumName, uint cost)
  {
    name = forumName;
    replyCost = cost;
  }

  function makePost(string title, bytes hash) constant returns(address)
  {
    Document newPost = new Document(hash);
    titles[address(newPost)] = title;
    timeStamp[address(newPost)] = now;
    return address(newPost);
  }

  function addTag(address post, string tagToAdd)
  {
    tag[tagToAdd].push(post);
    postTags[post].push(tagToAdd);
  }

  function makeReply(string title, bytes hash, address replyTo, uint weight)
  {
    if(msg.value >= replyCost)
    {
      if(replyTo.send(msg.value) == false)
      {
        throw;
      }
      address reply = makePost(title, hash);
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
