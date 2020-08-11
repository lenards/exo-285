module Main exposing (main)

import Browser
import Color
import Color.Convert exposing (hexToColor)
import Element exposing (Element)
import FeatherIcons
import Widget
import Widget.Style exposing (ButtonStyle, RowStyle)
import Widget.Style.Material as Material


defaultPalette : Material.Palette
defaultPalette =
    { primary = Color.rgb255 0x62 0x00 0xEE
    , secondary = Color.rgb255 0x03 0xDA 0xC6
    , background = Color.rgb255 0xFF 0xFF 0xFF
    , surface = Color.rgb255 0xFF 0xFF 0xFF
    , error = Color.rgb255 0xB0 0x00 0x20
    , on =
        { primary = Color.rgb255 0xFF 0xFF 0xFF
        , secondary = Color.rgb255 0x00 0x00 0x00
        , background = Color.rgb255 0x00 0x00 0x00
        , surface = Color.rgb255 0x00 0x00 0x00
        , error = Color.rgb255 0xFF 0xFF 0xFF
        }
    }


type alias Flags =
    { primary : String -- Color --Color.rgb255 0x62 0x00 0xEE
    , secondary : String -- Color --Color.rgb255 0x03 0xda 0xc6
    , background : String -- Color --Color.rgb255 0xFF 0xFF 0xFF
    , surface : String -- Color --Color.rgb255 0xFF 0xFF 0xFF
    , error : String -- Color --Color.rgb255 0xB0 0x00 0x20
    }


type alias Style style msg =
    { style
        | primaryButton : ButtonStyle msg
        , button : ButtonStyle msg
        , row : RowStyle msg
    }


materialStyle : Material.Palette -> Style {} msg
materialStyle palette =
    { primaryButton = Material.containedButton palette
    , button = Material.outlinedButton palette
    , row = Material.row
    }


type alias Model =
    { isButtonEnabled : Bool
    , currentPalette : Material.Palette
    }


type Msg
    = ChangedButtonStatus Bool


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        palette =
            { primary =
                flags.primary
                    |> hexToColor
                    |> Result.toMaybe
                    |> Maybe.withDefault
                        (Color.rgb255 0xFF 0xFF 0xFF)
            , secondary =
                flags.secondary
                    |> hexToColor
                    |> Result.toMaybe
                    |> Maybe.withDefault
                        (Color.rgb255 0xFF 0xFF 0xFF)
            , background =
                flags.background
                    |> hexToColor
                    |> Result.toMaybe
                    |> Maybe.withDefault
                        (Color.rgb255 0xFF 0xFF 0xFF)
            , surface =
                flags.surface
                    |> hexToColor
                    |> Result.toMaybe
                    |> Maybe.withDefault
                        (Color.rgb255 0xFF 0xFF 0xFF)
            , error =
                flags.error
                    |> hexToColor
                    |> Result.toMaybe
                    |> Maybe.withDefault
                        (Color.rgb255 0xFF 0xFF 0xFF)
            , on =
                { primary = Color.rgb255 0xFF 0xFF 0xFF
                , secondary = Color.rgb255 0x00 0x00 0x00
                , background = Color.rgb255 0x00 0x00 0x00
                , surface = Color.rgb255 0x00 0x00 0x00
                , error = Color.rgb255 0xFF 0xFF 0xFF
                }
            }
    in
    ( Model True palette
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangedButtonStatus bool ->
            ( { model | isButtonEnabled = bool }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


{-| You can remove the msgMapper. But by doing so, make sure to also change `msg` to `Msg` in the line below.
-}
view : (Msg -> msg) -> Model -> Element msg
view msgMapper model =
    let
        isButtonEnabled =
            model.isButtonEnabled

        palette =
            model.currentPalette
    in
    [ Widget.button (Material.containedButton palette)
        { text = "disable me"
        , icon =
            FeatherIcons.slash
                |> FeatherIcons.withSize 16
                |> FeatherIcons.toHtml []
                |> Element.html
                |> Element.el []
        , onPress =
            if isButtonEnabled then
                ChangedButtonStatus False
                    |> msgMapper
                    |> Just

            else
                Nothing
        }
    , Widget.iconButton (Material.containedButton palette)
        { text = "reset"
        , icon =
            FeatherIcons.repeat
                |> FeatherIcons.withSize 16
                |> FeatherIcons.toHtml []
                |> Element.html
                |> Element.el []
        , onPress =
            ChangedButtonStatus True
                |> msgMapper
                |> Just
        }
    ]
        |> Widget.row Material.row


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view identity >> Element.layout []
        , update = update
        , subscriptions = subscriptions
        }
