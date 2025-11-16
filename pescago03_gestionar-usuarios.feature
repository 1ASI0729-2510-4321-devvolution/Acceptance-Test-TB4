Feature: Gestionar usuarios
  Como administrador o usuario de la plataforma
  Quiero poder registrar y validar usuarios
  Para garantizar que el correo y la contraseña cumplan las reglas de negocio

  Background:
    Given la API está disponible en "/api/users"
    And el header "Content-Type" está configurado como "application/json"
    And existe un usuario administrador con un token válido

  @happy-path
  Scenario: Registrar usuario con correo y contraseña válidos
    Given el administrador posee un token de autorización válido
    And el siguiente payload de usuario:
      """
      {
        "email": "usuario.valido@example.com",
        "password": "P@ssw0rd123",
        "firstName": "Carlos",
        "lastName": "Gonzales",
        "role": "entrepreneur"
      }
      """
    When se realiza una petición POST a "/api/users"
    Then la respuesta tiene el código de estado 201
    And la respuesta contiene un campo "id" no vacío
    And la respuesta contiene "email" igual a "usuario.valido@example.com"

  @validation
  Scenario: Registrar usuario con correo inválido devuelve error de validación
    Given el administrador posee un token de autorización válido
    And el siguiente payload de usuario con email inválido:
      """
      {
        "email": "correo-invalido",
        "password": "P@ssw0rd123",
        "firstName": "Ana",
        "lastName": "Rivas",
        "role": "carrier"
      }
      """
    When se realiza una petición POST a "/api/users"
    Then la respuesta tiene el código de estado 400
    And la respuesta contiene un mensaje de validación indicando que "email" no tiene formato válido

  @validation
  Scenario: Registrar usuario con contraseña débil devuelve error de validación
    Given el administrador posee un token de autorización válido
    And el siguiente payload de usuario con contraseña débil:
      """
      {
        "email": "usuario2@example.com",
        "password": "12345",
        "firstName": "Luis",
        "lastName": "Flores",
        "role": "entrepreneur"
      }
      """
    When se realiza una petición POST a "/api/users"
    Then la respuesta tiene el código de estado 400
    And la respuesta contiene un mensaje de validación indicando que la "password" no cumple los requisitos mínimos
