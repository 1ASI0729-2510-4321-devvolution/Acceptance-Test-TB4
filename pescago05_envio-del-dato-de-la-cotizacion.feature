Feature: Envío del dato de la cotización
  Como empresario o empresa transportista
  Quiero consultar el dato de la cotización (precio) de un servicio
  Para decidir si aceptar o rechazar la oferta

  Background:
    Given la API está disponible en "/api/quotations"
    And existe un usuario autenticado con un token válido
    And el header "Accept" está configurado como "application/json"

  @happy-path
  Scenario: Obtener precio de cotización por ID válido
    Given el usuario posee un token de autorización válido
    And existe una cotización con id "cot-456" asociada a la solicitud "req-123"
    When se realiza una petición GET a "/api/quotations/cot-456/price"
    Then la respuesta tiene el código de estado 200
    And la respuesta contiene un campo "price" con valor numérico mayor que 0
    And la respuesta contiene "currency" igual a "PEN"
    And la respuesta contiene "quotationId" igual a "cot-456"

  @not-found
  Scenario: Consultar precio de cotización inexistente devuelve 404
    Given el usuario posee un token de autorización válido
    And no existe una cotización con id "cot-999"
    When se realiza una petición GET a "/api/quotations/cot-999/price"
    Then la respuesta tiene el código de estado 404
    And la respuesta contiene un mensaje indicando "quotation not found"

  @auth
  Scenario: Consultar precio sin token devuelve 401
    Given no se proporciona token de autorización
    When se realiza una petición GET a "/api/quotations/cot-456/price"
    Then la respuesta tiene el código de estado 401
    And la respuesta contiene un mensaje indicando "unauthorized"
