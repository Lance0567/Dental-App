unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.MultiView, FMX.TabControl, FMX.StdCtrls,
  FMX.Objects;

type
  TfrmMain = class(TForm)
    lytContainer: TLayout;
    lytSidebar: TLayout;
    mvSidebar: TMultiView;
    sbSettings: TSpeedButton;
    sbMenu: TSpeedButton;
    sbAppointments: TSpeedButton;
    sbDashboard: TSpeedButton;
    sbPatients: TSpeedButton;
    lytContent: TLayout;
    ToolBar1: TToolBar;
    lytMenuH: TLayout;
    lbMainMenu: TLabel;
    lDivider: TLine;
    lSidebarWidth: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure mvSidebarResize(Sender: TObject);
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

{ Form create }
procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // default Show sidebar
  mvSidebar.ShowMaster;
  mvSidebar.NavigationPaneOptions.CollapsedWidth := 50;
end;

{ Form Resized }
procedure TfrmMain.mvSidebarResize(Sender: TObject);
begin
  // Sidebar width identifier
  lSidebarWidth.Text := 'Sidebar width: ' + mvSidebar.Width.ToString;

  // Sidebar adjustment
  if mvSidebar.Width < 51 then
  begin
    lbMainMenu.Visible := false;
    lDivider.Visible := true;
  end
  else
  begin
    lbMainMenu.Visible := true;
    lDivider.Visible := false;
  end;
end;

end.
