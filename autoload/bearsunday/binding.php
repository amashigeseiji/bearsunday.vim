<?php
/**
 * BEAR.Sunday DI Binding
 *
 * Usage:
 *   php binding.php [-f filter] dir=/path/to/bear name='App\Name' context=prod-app
 *
 * Arguments:
 *   - dir=<path>        path to bearsunday directory.
 *   - name=<appname>    vendor prefix
 *   - context=<context> context name
 *
 * Options:
 *   - -f <filter>       filter word
 */
$filter = getopt('f:');
foreach ($argv as $arg) {
    if (strpos($arg, '=') === false) {
        continue;
    }
    $split = explode('=', $arg);
    if (in_array($split[0], ['dir', 'name', 'context'], true)) {
        ${$split[0]} = $split[1];
    }
}

require $dir . '/autoload.php';

use BEAR\AppMeta\Meta;
use BEAR\Package\AppInjector;

$json = new binding($name, $context, $dir);
if ($filter) {
    $json->filter($filter['f']);
}
echo $json;

class binding
{
    private $name;
    private $context;
    private $cacheDir;
    private $filter = [];

    public function __construct($name, $context, $cacheDir)
    {
        $this->name = $name;
        $this->context = $context;
        $this->cacheDir = $cacheDir;
    }

    public function filter(string $word)
    {
        $this->filter[] = $word;
    }

    public function __toString()
    {
        $dep = $this->make();
        return json_encode($dep, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
    }

    private function make()
    {
        $container = $this->getContainer($this->name, $this->context, $this->cacheDir);
        $dependency = [];
        foreach ($container as $interface => $obj) {
            if ($this->filter) {
                $filtered = array_filter($this->filter, function ($filter) use ($interface) {
                    return preg_match('@'.$filter.'@i', $interface);
                });
            }
            if (empty($filtered)) {
                continue;
            }
            $class = get_class($obj);
            switch ($class) {
            case 'Ray\Di\Instance':
                $bind = is_object($obj->value) ? get_class($obj->value) : $obj->value;
                break;
            case 'Ray\Di\Dependency':
                $bind = self::getPrivate(self::getPrivate($obj, 'newInstance'), 'class');
                break;
            case 'Ray\Di\DependencyProvider':
                $bind = self::getPrivate(self::getPrivate(self::getPrivate($obj, 'dependency'), 'newInstance'), 'class');
                break;
            default:
                $bind = get_class($obj);
        }
            $dependency[$interface] = $bind;
        }

        return $dependency;
    }

    private function getContainer()
    {
        $injector = new AppInjector($this->name, $this->context, new Meta($this->name, $this->context), $this->cacheDir);
        $reflection = new ReflectionObject($injector);
        $method = $reflection->getMethod('getModule');
        $method->setAccessible(true);
        $module = $method->invoke($injector);

        return self::getPrivate($module->getContainer(), 'container');
    }

    private static function getPrivate($object, string $property)
    {
        $ref = new ReflectionClass($object);
        $prop = $ref->getProperty($property);
        $prop->setAccessible(true);

        return $prop->getValue($object);
    }
}
