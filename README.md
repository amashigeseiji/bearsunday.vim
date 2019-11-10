# BEAR.Sunday vim plugin

## Resource Access

`BEARResource` calls api from editing buffer.

usage:

```vim
:BEARResource {method} [{params}]
```

example:

```vim
:BEARResource get id=3 name=Foo
```

and response buffer will open.

```
php bin/page.php get /editingResource?id=3&name=Foo


"200 OK",
"Content-Type: application/hal+json",
"ETag: 703429597",
"Last-Modified: Sun, 10 Nov 2019 06:47:53 GMT",

{
  "message": "hello"
}
```

you can close buffer with type `q`.

## Skeleton

if you open new file in `src/Resource/App` or `src/Resource/Page` , new file will open with skeleton code.

example:

```sh
# in your shell
$ vim src/Resource/App/SomeNewResource.php
```

```php
<?php
namespace Vendor\Prefix\Resource\App;

use BEAR\Resource\ResourceObject;

class SomeNewResource extends ResourceObject
{
    public function onGet() : ResourceObject
    {
    }
}
```

`Vendor\Prefix` in namespace will be replaced by `composer.json`'s `autoload.psr-4` setting.
