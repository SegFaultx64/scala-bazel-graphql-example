package services

trait CachingBehavior {
  class Cachable[K, V](get: (K) => V) {
    def makeCachable(): (K) => V = {
      get
    }

    def apply(k: K): V = {
      get(k)
    }
  }

  type ==>[K, V] = Cachable[K, V]

  def cachable[K, V](get: (K) => V): K ==> V = {
    new Cachable[K, V](get)
  }
}

trait InMemoryCaching extends CachingBehavior {
  class Cachable[K, V](get: (K) => V) extends super.Cachable(get) {
    var cache = Map[K, V]()
    lazy val withCaching = makeCachable()

    override def makeCachable(): (K) => V = { (key: K) =>
      {
        val cached = cache.get(key)

        cached match {
          case None => {
            val temp = get(key)
            if (!temp.isInstanceOf[Option[_]] || temp
                  .asInstanceOf[Option[_]]
                  .isDefined) {
              cache = cache + ((key, temp))
            }
            temp
          }
          case Some(value) => value
        }
      }
    }

    override def apply(k: K): V = {
      withCaching(k)
    }

  }

  override def cachable[K, V](get: (K) => V): Cachable[K, V] = {
    new Cachable[K, V](get)
  }
}