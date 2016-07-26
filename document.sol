contract Document
{
  string data;
  address author;
  address[] sources;
  mapping (address => uint) weights;

  modifier onlyAuthor
  {
    if(msg.sender != author)
    {
      throw;
    }
  }

  function Document(string dataHash)
  {
    data = dataHash;
    author = msg.sender;
  }

  function getData() constant returns(string)
  {
    return data;
  }

  function addSource(address source, uint weight) onlyAuthor
  {
    sources.push(source);
    weights[source] = weight;
  }

  function modifySourceWeight(address source, uint newValue) onlyAuthor
  {
    weights[source] = newValue;
  }

  function removeSource(address source) onlyAuthor
  {
    address[] memory newSources = new address[] (sources.length - 1);
    uint j = 0;
    for(uint i = 0; i < sources.length; i++)
    {
      if(source != sources[i])
      {
        newSources[j] = sources[i];
        j++;
      }
    }
    sources = newSources;
  }

  function getWeight(address requestedAddress) constant returns(uint)
  {
    return weights[requestedAddress];
  }

  function modifyAuthor(address newAuthor) onlyAuthor
  {
    author = newAuthor;
  }

  function getAuthor() constant returns(address)
  {
    return author;
  }

  function setAuthorWeight(uint weight) onlyAuthor
  {
    weights[author] = weight;
  }

  function getTotalWeight() returns(uint)
  {
    uint total = weights[author];
    for(uint i = 0; i < sources.length; i++)
    {
      total += weights[sources[i]];
    }
    return total;
  }

  function pay()
  {
    var amount = msg.value;
    var total = getTotalWeight();
    if(author.send(amount*(weights[author]/total)) == false)
    {
      throw;
    }
    for(uint j = 0; j < sources.length; j++)
    {
      if(sources[j].send(weights[sources[j]]/total) == false)
      {
        throw;
      }
    }
  }

  function payout()
  {
    var amount = this.balance;
    var total = getTotalWeight();
    if(author.send(amount*(weights[author]/total)) == false)
    {
      throw;
    }
    for(uint k = 0; k < sources.length; k++)
    {
      if(sources[k].send(weights[sources[k]]/total) == false)
      {
        throw;
      }
    }
  }
}
