import "document.sol";

contract Forum
{
  mapping (address => string) titles;
  mapping (address => uint) timeStamp;
  mapping (address => uint) replyCost;
  mapping (string => address[]) tag;
  mapping (address => address[]) replies;
  mapping (address => string[]) postTags;

  function forum()
  {

  }

  function makePost(string title, bytes hash, uint costToReply) returns(address)
  {
    Document newPost = new Document(hash);
    titles[address(newPost)] = title;
    replyCost[address(newPost)] = costToReply;
    timeStamp[address(newPost)] = now;
    return address(newPost);
  }

  function addTag(address post, string tagToAdd)
  {
    tag[tagToAdd].push(post);
    postTags[post].push(tagToAdd);
  }

  function makeReply(string title, bytes hash, address replyTo, uint weight, uint costToReply)
  {
    if(msg.value >= replyCost[replyTo])
    {
      replyTo.send(msg.value);
      address reply = makePost(title, hash, costToReply);
      replies[replyTo].push(reply);
      Document(reply).addSource(replyTo, weight);
    }
  }

  function getTitle(address post) returns(string)
  {
    return titles[post];
  }

  function getReplies(address post) returns(address[])
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
