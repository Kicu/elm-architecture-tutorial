import Browser
import Html exposing (Html, Attribute, div, input, text, button)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)


main =
  Browser.sandbox { init = init, update = update, view = view }

type alias Model =
  { name : String
  , password : String
  , repeatPassword : String
  , showValidation : Bool
  }

init : Model

init =
  { name = ""
  , password = ""
  , repeatPassword = ""
  , showValidation = False
  }

type Msg
  = Name String
  | Password String
  | RepeatPassword String
  | ShowValidation

update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name}
        Password password ->
            { model | password = password}
        RepeatPassword repeatPassword ->
            { model | repeatPassword = repeatPassword }
        ShowValidation ->
            { model | showValidation = True }

viewInput : String -> String -> String -> (String -> Msg) -> Html Msg
viewInput t p v toMsg =
    input [ type_ t, value v, placeholder p, onInput toMsg] []

viewError : String -> Html Msg
viewError errorMessage =
    div [ style "color" "red"] [ text errorMessage ]

viewValidation : Model -> Html Msg
viewValidation model =
    if String.length model.password < 8 && model.password /= "" then
      viewError "Passwords must be at least 8 characters"
    else if model.password == model.repeatPassword then
      div [ style "color" "green" ] [ text "OK" ]
    else
      viewError "Passwords do not match!"

view: Model -> Html Msg
view model =
    div []
    [ viewInput "text" "Name" model.name Name
    , viewInput "password" "Password" model.password Password
    , viewInput "password" "Repeat password" model.repeatPassword RepeatPassword
    , button [ onClick ShowValidation ] [ text "Submit" ]
    , if model.showValidation then viewValidation model else text ""
    ]