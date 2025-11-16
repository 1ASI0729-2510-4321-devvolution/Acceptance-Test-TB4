Feature: Agregar solicitud del empresario pesquero
  Como empresario pesquero
  Quiero registrar una solicitud de transporte de producto pesquero
  Para que las empresas prestadoras de vehículos puedan ofrecer cotizaciones

  Background:
    Given la API está disponible en "/api/requests"
    And existe un usuario empresario con un token válido
    And el header "Content-Type" está configurado como "application/json"

  @happy-path
  Scenario: Crear solicitud con todos los datos válidos
    Given el empresario posee un token de autorización válido
    And el siguiente payload de solicitud:
      """
      {
        "name": "Juan Perez",
        "product": "Atún fresco",
        "quantity": 200,
        "origin": "Puerto de San José",
        "destination": "Planta Procesadora del Norte",
        "date": "2025-12-05T08:00:00"
      }
      """
    When se realiza una petición POST a "/api/requests"
    Then la respuesta tiene el código de estado 201
    And la respuesta contiene un campo "id" no vacío
    And la respuesta contiene "name" igual a "Juan Perez"
    And la respuesta contiene "product" igual a "Atún fresco"

  @validation
  Scenario: Crear solicitud sin producto devuelve error de validación
    Given el empresario posee un token de autorización válido
    And el siguiente payload de solicitud con campo "product" vacío:
      """
      {
        "name": "María López",
        "product": "",
        "quantity": 50,
        "origin": "Caleta del Sur",
        "destination": "Mercado Central",
        "date": "2025-11-20T10:30:00"
      }
      """
    When se realiza una petición POST a "/api/requests"
    Then la respuesta tiene el código de estado 400
    And la respuesta contiene un mensaje de validación indicando que "product" es requerido
