*** Settings***

Resource    ../resources/keywords.resource

Suite Setup    Create Session    alias=iqs    url=${BASE_URL}

*** Test Cases ***
TC3: obter reservas
    [Tags]    Reservas
      
    ${response}    GET /booking    200
    Validate Json    ${response}    GetBooking.json

TC4: obter reserva por ID
     [Tags]    ID
    ${bookingid}    Select Random BookingId From Booking List
    ${response}    GET /booking/${bookingid}    200
    Validate Json    ${response}    GetBookinglds.json

TC5: criar reserva
    [Tags]    CRIAR
        
    ${payload}    Load Json From File    ${PAYLOAD_DIR}/PostBooking.json
    ${response}    POST On Session    iqs    /booking    json=${payload}    expected_status=200
    Validate Json    ${response}    CreateBooking.json

    ${booking}    Set Variable    ${response.json()}[booking] 
    ${bookingid}    Set Variable    ${response.json()}[bookingid]

    ${response}    GET On Session    iqs    /booking/${bookingid}    expected_status=200
    Dictionaries Should Be Equal    ${response.json()}    ${booking}

TC6: substituir reserva
    [Tags]    SUBSTITUIR

    ${bookingid}    Select Random BookingId From Booking List
    ${response}    PUT /booking/${bookingid}    PutBooking.json    200
   
    Validate Json    ${response}    UpdateBooking.json

    ${newResponse}    GET /booking/${bookingid}    200
    Dictionaries Should Be Equal    ${newResponse.json()}    ${response.json()}

TC7: editar reserva
    [Tags]    EDITAR

    ${bookingid}    Select Random BookingId From Booking List
    ${response}    PATCH /booking/${bookingid}    PatchBooking.json    200

    Validate Json    ${response}    UpdateBooking.json

    ${newResponse}    GET /booking/${bookingid}    200
    Dictionaries Should Be Equal    ${newResponse.json()}    ${response.json()}

TC8: deletar reserva
    [Tags]    DELETAR

    ${bookingid}    Select Random BookingId From Booking List
    ${response}    DELETE /booking/${bookingid}    201
    
    GET /booking/${bookingid}    404

    ${response}    GET /booking    200
    Should Not Have Value In Json    ${response.json()}    $[?(@.bookingid == ${bookingid})].bookingid