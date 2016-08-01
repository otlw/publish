contract Document
{
  string data;
  address[] authors;
  address[] sources;
  mapping (address => uint) weights;

  modifier onlyAuthors
  {
    bool x = false;
    for(uint i = 0; x==false && i < authors.length; i++)
    {
      if(msg.sender == authors[i])
      {
        x = true;
      }
    }
    if(x == false)
    {
      throw;
    }
  }

  function Document(string dataHash, address[] authorAddresses, uint[] authorWeights)
  {
    data = dataHash;
    authors = authorAddresses;
    for(uint i = 0; i < authorWeights.length; i++)
    {
      weights[authorAddresses[i]] = authorWeights[i];
    }
  }

  function getData() constant returns(string)
  {
    return data;
  }

  function addSource(address source, uint weight) onlyAuthors
  {
    sources.push(source);
    weights[source] = weight;
  }

  function modifySourceWeight(address source, uint newValue) onlyAuthors
  {
    weights[source] = newValue;
  }

  function removeSource(address source) onlyAuthors
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

  function modifyAuthor(address[] newAuthors) onlyAuthors
  {
    authors = newAuthors;
  }

  function getAuthors() constant returns(address[])
  {
    return authors;
  }

  function setAuthorWeight(uint weight) onlyAuthors
  {
    weights[msg.sender] = weight;
  }

  function getTotalWeight() returns(uint)
  {
    uint total = 0;
    for(uint j = 0; j < authors.length; j++)
    {
      total += weights[authors[j]];
    }
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
    for(uint i = 0; i < authors.length; i++)
    {
      if(authors[i].send(amount*(weights[authors[i]]/total)) == false)
      {
        throw;
      }
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
    for(uint i = 0; i < authors.length; i++)
    {
      if(authors[i].send(amount*(weights[authors[i]]/total)) == false)
      {
        throw;
      }
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
