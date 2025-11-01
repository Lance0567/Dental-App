unit uContactInfo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ImgList, FMX.Controls.Presentation, FMX.Objects, FMX.Layouts;

type
  TfContactInfo = class(TFrame)
    lytContentH: TLayout;
    rBackground: TRectangle;
    rModalInfo: TRectangle;
    lytPatientProfile: TLayout;
    lytTitle: TLayout;
    lbTitle: TLabel;
    btnClose: TSpeedButton;
    lLance: TLabel;
    lNumber1: TLabel;
    lFrnacis: TLabel;
    lNumber2: TLabel;
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uMain;

{ Close button }
procedure TfContactInfo.btnCloseClick(Sender: TObject);
begin
  Self.Visible := False;
end;

end.
