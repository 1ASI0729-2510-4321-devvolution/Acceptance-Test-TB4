Feature: Información sobre vehículo y conductor
  Como empresa o administrador
  Quiero obtener información detallada del vehículo y su conductor
  Para verificar que el transporte cumple los requisitos antes de aceptar una solicitud

  Background:
    Given la API está disponible en "/api/vehicles"
    And existe un usuario autenticado con un token válido
    And el header "Accept" está configurado como "application/json"

  @happy-path
  Scenario: Obtener datos de vehículo y conductor por ID existente
    Given el usuario posee un token de autorización válido
    And existe un vehículo con id "veh-123"
    When se realiza una petición GET a "/api/vehicles/veh-123"
    Then la respuesta tiene el código de estado 200
    And la respuesta contiene "plate" (no vacío)
    And la respuesta contiene "model" igual a "Isuzu NPR"
    And la respuesta contiene "capacity" igual a 120
    And la respuesta contiene un objeto "driver" con "name" igual a "Pedro Alvarado"
    And el objeto "driver" contiene "licenseNumber" no vacío

  @not-found
  Scenario: Obtener datos con ID inexistente devuelve 404
    Given el usuario posee un token de autorización válido
    And no existe un vehículo con id "veh-999"
    When se realiza una petición GET a "/api/vehicles/veh-999"
    Then la respuesta tiene el código de estado 404
    And la respuesta contiene un mensaje indicando "vehicle not found"

  @auth
  Scenario: Obtener datos sin token devuelve 401
    Given no se proporciona token de autorización
    When se realiza una petición GET a "/api/vehicles/veh-123"
    Then la respuesta tiene el código de estado 401
    And la respuesta contiene un mensaje indicando "unauthorized"
