package services.tests

import services.InMemoryCaching
import org.scalatest._

class Mock extends InMemoryCaching {
  var calcs = 0;

  val reverseString = cachable((v: String) => {
    calcs += 1;
    if (v == "none") {
      None
    } else {
      Some(v.reverse)
    }
  })
  
  val otherCachedFunction = cachable((v: String) => {
    calcs += 1;
    v.reverse
  })
}

class InMemoryCachingSpec extends FlatSpec {
  "An in memory cache" should "execute a cachable function" in {
    val mock = new Mock()
    assert(mock.reverseString("test") == Some("tset"))
  }
  it should "store values in memory" in {
    val mock = new Mock()
    mock.reverseString("test")
    assert(mock.reverseString.cache.get("test").isDefined)
    assert(mock.reverseString.cache.get("test").get == Some("tset"))
    assert(mock.reverseString.cache.size == 1)
  }
  it should "not recompute known values" in {
    val mock = new Mock()
    assert(mock.calcs == 0)
    mock.reverseString("test")
    mock.reverseString("test")
    mock.reverseString("test")
    assert(mock.reverseString.cache.get("test").isDefined)
    assert(mock.reverseString.cache.size == 1)
    assert(mock.calcs == 1)
  }
  it should "not store `None` values in memory" in {
    val mock = new Mock()
    mock.reverseString("none")
    assert(!mock.reverseString.cache.get("none").isDefined)
    assert(mock.reverseString.cache.size == 0)
  }
  it should "not pollute caches across functions" in {
    val mock = new Mock()
    mock.reverseString("abc")
    mock.reverseString("abc")
    mock.otherCachedFunction("abc")
    mock.otherCachedFunction("abc")
    assert(mock.calcs == 2)
  }
  it should "be able to evict from the cache" in {
    val mock = new Mock()
    mock.reverseString("abc")
    mock.reverseString("abc")
    mock.reverseString.evict("abc")
    mock.reverseString("abc")
    assert(mock.calcs == 2)
  }
}



