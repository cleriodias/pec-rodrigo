<?php

namespace Tests;

use Illuminate\Contracts\Console\Kernel;
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Testing\TestCase as BaseTestCase;
use RuntimeException;

abstract class TestCase extends BaseTestCase
{
    public function createApplication()
    {
        $appEnv = $_ENV['APP_ENV'] ?? $_SERVER['APP_ENV'] ?? getenv('APP_ENV') ?: null;

        if ($appEnv === 'testing') {
            putenv('DB_CONNECTION=sqlite');
            putenv('DB_DATABASE=:memory:');
            $_ENV['DB_CONNECTION'] = 'sqlite';
            $_ENV['DB_DATABASE'] = ':memory:';
            $_SERVER['DB_CONNECTION'] = 'sqlite';
            $_SERVER['DB_DATABASE'] = ':memory:';
        }

        $app = require Application::inferBasePath().'/bootstrap/app.php';

        $app->make(Kernel::class)->bootstrap();

        if ($app->environment('testing')) {
            $defaultConnection = (string) $app['config']->get('database.default');
            $databaseName = (string) $app['config']->get("database.connections.{$defaultConnection}.database");

            if ($defaultConnection !== 'sqlite' || $databaseName !== ':memory:') {
                throw new RuntimeException(
                    'Ambiente de teste inseguro bloqueado: testes so podem rodar com sqlite em memoria.'
                );
            }
        }

        return $app;
    }
}
