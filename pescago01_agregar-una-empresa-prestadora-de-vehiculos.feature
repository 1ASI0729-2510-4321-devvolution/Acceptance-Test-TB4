Feature: Agregar una empresa prestadora de vehículos
  Como administrador del sistema
  Quiero poder registrar una empresa prestadora de vehículos
  Para que pueda ofrecer servicios de transporte dentro de la plataforma

  Background:
    Given la API está disponible en "/api/companies"
    And existe un usuario administrador con un token válido
    And el header "Content-Type" está configurado como "application/json"

  @happy-path
  Scenario: Registrar empresa con datos válidos
    Given el administrador posee un token de autorización válido
    And el siguiente payload de empresa:
      """
      {
        "name": "Transporte del Mar S.A.",
        "ruc": "20512345678",
        "address": "Av. Principal 123, Callao",
        "phone": "+511987654321",
        "email": "contacto@transportemar.com",
        "vehicleTypes": ["camion", "furgon"],
        "capacity": 150
      }
      """
    When se realiza una petición POST a "/api/companies"
    Then la respuesta tiene el código de estado 201
    And la respuesta contiene un campo "id" no vacío
    And la respuesta contiene "name" igual a "Transporte del Mar S.A."

  @validation
  Scenario: Registrar empresa con correo inválido provoca error de validación
    Given el administrador posee un token de autorización válido
    And el siguiente payload de empresa con email inválido:
      """
      {
        "name": "Empresa Pesquera S.A.",
        "ruc": "20498765432",
        "address": "Muelle 4",
        "phone": "+511912345678",
        "email": "correo-no-valido",
        "vehicleTypes": ["camion"],
        "capacity": 80
      }
      """
    When se realiza una petición POST a "/api/companies"
    Then la respuesta tiene el código de estado 400
    And la respuesta contiene un mensaje de validación indicando "email" inválido
