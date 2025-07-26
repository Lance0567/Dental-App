unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.MultiView, FMX.TabControl, FMX.StdCtrls,
  FMX.Objects, uDashboard, FMX.ImgList, uPatients, uAppointments;

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
    tcController: TTabControl;
    tiDashboard: TTabItem;
    tiPatients: TTabItem;
    fPatients: TfPatients;
    tiAppointments: TTabItem;
    fAppointments: TfAppointments;
    procedure FormCreate(Sender: TObject);
    procedure mvSidebarResize(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tcControllerChange(Sender: TObject);
    procedure sbPatientsClick(Sender: TObject);
    procedure sbDashboardClick(Sender: TObject);
    procedure sbAppointmentsClick(Sender: TObject);
  private
    procedure HideFrames;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses uDm;

{ Hide Frames }
procedure TfrmMain.HideFrames;
begin
  fDashboard.Visible := False;
  fPatients.Visible := False;
  fAppointments.Visible := False;
end;

{ Form create }
procedure TfrmMain.FormCreate(Sender: TObject);
begin
  // Default Show sidebar
  mvSidebar.ShowMaster;
  mvSidebar.NavigationPaneOptions.CollapsedWidth := 50;
end;

{ Form Resized }
procedure TfrmMain.FormResize(Sender: TObject);
begin
  // Form Caption
  Self.Caption := 'Dental System | '+ 'Height: ' +
  Self.ClientHeight.ToString + ', ' + 'Width: ' + Self.ClientWidth.ToString + ' Card width: '
  + fDashboard.glytCards.Width.ToString + ' Card height: ' + fDashboard.glytCards.Height.ToString;

  if Self.ClientHeight < 505 then
  begin
    Self.Height := 505;
  end;

  if Self.ClientWidth < 835 then
  begin
    Self.Width := 835;
  end;

  // Dashboard cards resize
  fDashboard.CardsResize;

  // Records layout
  if Self.ClientWidth > 1900 then
  begin
    fDashboard.lytRecords.Align := TAlignLayout.Client;
  end
  else
  begin
    fDashboard.lytRecords.Align := TAlignLayout.Top;
    fDashboard.lytRecords.Height := 390;
  end;
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  // Dashboard cards resize
  fDashboard.CardsResize;
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

  fDashboard.CardsResize;
end;

{ Appointments tab }
procedure TfrmMain.sbAppointmentsClick(Sender: TObject);
begin
  // Hide frames
  HideFrames;

  // Switch tab index
  tcController.TabIndex := 2;
  fAppointments.Visible := True;
end;

{ Dashboard tab }
procedure TfrmMain.sbDashboardClick(Sender: TObject);
begin
  // Hide frames
  HideFrames;

  // Switch tab index
  tcController.TabIndex := 0;
  fDashboard.Visible := True;
  fDashboard.ScrollBox1.ViewportPosition := PointF(0,0); // reset scrollbox
end;

{ Patients tab }
procedure TfrmMain.sbPatientsClick(Sender: TObject);
begin
  // Hide frames
  HideFrames;

  // Switch tab index
  tcController.TabIndex := 1;
  fPatients.Visible := True;
  fPatients.ScrollBox1.ViewportPosition := PointF(0,0); // reset scrollbox
end;

procedure TfrmMain.tcControllerChange(Sender: TObject);
begin
  case tcController.TabIndex of
    0:
  end;
end;

end.
