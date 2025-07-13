unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.MultiView, FMX.TabControl, FMX.StdCtrls,
  FMX.Objects, uDashboard, FMX.ImgList;

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
    lytMenuH: TLayout;
    lbMainMenu: TLabel;
    lDivider: TLine;
    fDashboard: TfDashboard;
    procedure FormCreate(Sender: TObject);
    procedure mvSidebarResize(Sender: TObject);
    procedure FormResize(Sender: TObject);
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

  // Form Caption
  Self.Caption := 'Dental System | '+ 'Height: ' +
  Self.Height.ToString + ', ' + 'Width: ' + Self.Width.ToString;
end;

{ Form Resized }
procedure TfrmMain.FormResize(Sender: TObject);
begin
  if Self.Height >= 544 then
  begin
    fDashboard.glytCards.Height := 170;
  end
  else
  begin
    fDashboard.glytCards.Height := 300;
  end;
end;

{ Sidebar Resized }
procedure TfrmMain.mvSidebarResize(Sender: TObject);
begin
  // Date formatted
  fDashboard.lDate.Text :=  FormatDateTime('dddd, mmmm d, yyyy', Now);;

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

  // Adjust layout holder
  lytSidebar.Width := mvSidebar.Width;
end;

end.
