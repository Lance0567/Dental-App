unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.MultiView, FMX.TabControl, FMX.StdCtrls;

type
  TfrmMain = class(TForm)
    lytContainer: TLayout;
    lytSidebar: TLayout;
    lytContent: TLayout;
    tcController: TTabControl;
    mvSidebar: TMultiView;
    sbMenu: TSpeedButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses uDm;

end.
