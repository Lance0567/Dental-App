unit uDashboard;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  System.Skia, System.Rtti, FMX.Grid.Style, FMX.Calendar, FMX.ScrollBox,
  FMX.Grid, FMX.Skia, FMX.ImgList, FMX.Controls.Presentation, FMX.Objects,
  FMX.Layouts, Math, FMX.Ani, FMX.Menus, FMX.ExtCtrls, FMX.MultiView;

type
  TfDashboard = class(TFrame)
    ScrollBox1: TScrollBox;
    glytCards: TGridLayout;
    lytHeader: TLayout;
    lbTitle: TLabel;
    lbDescription: TLabel;
    lytTitle: TLayout;
    rCard1: TRectangle;
    lytCardD1: TLayout;
    lbTotalPatients: TLabel;
    lbTotalPatientsC: TLabel;
    rCard2: TRectangle;
    lytCardD2: TLayout;
    lbAppointments: TLabel;
    lbTodaysAppointmentC: TLabel;
    rCard3: TRectangle;
    lytCardD3: TLayout;
    lbNewAppointments: TLabel;
    lbNewAppointmentsC: TLabel;
    rCard4: TRectangle;
    lytCardD4: TLayout;
    lbCompleted: TLabel;
    lbCompletedC: TLabel;
    cIcon1: TCircle;
    gIcon1: TGlyph;
    cIcon2: TCircle;
    gIcon2: TGlyph;
    cIcon3: TCircle;
    gIcon3: TGlyph;
    cIcon4: TCircle;
    gIcon4: TGlyph;
    rToolbar: TRectangle;
    lytToolbarH: TLayout;
    lDate: TLabel;
    gIcon: TGlyph;
    lytUser: TLayout;
    slUserName: TSkLabel;
    rrUserImage: TRoundRect;
    lBevel: TLine;
    PopupMenu1: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    rPopUp: TRectangle;
    FloatAnimation4: TFloatAnimation;
    mvPopUp: TMultiView;
    cbAccountSettings: TCornerButton;
    cbLogout: TCornerButton;
    lDivider: TLine;
    lytRecords: TLayout;
    rTodaysAppointment: TRectangle;
    lbTodayAppointments: TLabel;
    gTodaysAppointment: TGrid;
    rQuickActions: TRectangle;
    lytTwoColumns: TLayout;
    btnNewPatient: TCornerButton;
    FloatAnimation1: TFloatAnimation;
    btnNewAppointment: TCornerButton;
    FloatAnimation2: TFloatAnimation;
    btnReportAnIssue: TCornerButton;
    FloatAnimation3: TFloatAnimation;
    lbQuickActions: TLabel;
    procedure FrameResize(Sender: TObject);
  private

    { Private declarations }
  public
    procedure CardsResize;
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uDm, uMain;

{ Frame Resize }
procedure TfDashboard.FrameResize(Sender: TObject);
begin
  // Cards responsiveness
  CardsResize;

  // Display Resolution
  if (frmMain.ClientWidth >= 1920) then
  begin
    // Cards
    glytCards.Height := 160;

    // Quick Actions
    rQuickActions.Width := 340;

    // Button Text font size
    btnNewPatient.TextSettings.Font.Size := 14;
    btnNewAppointment.TextSettings.Font.Size := 14;
    btnReportAnIssue.TextSettings.Font.Size := 14;
  end
  else if (frmMain.ClientWidth >= 1600) then
  begin

  end
  else if (frmMain.ClientWidth >= 1366) then
  begin
    // Cards
    glytCards.Height := 160;

    // Quick Actions
    rQuickActions.Width := 260;
  end
  else if (frmMain.ClientWidth <= 850) then
  begin
    // Cards
    glytCards.Height := 290;

    // Quick Actions
    rTodaysAppointment.Width := 280;
    rQuickActions.Width := 230;

    // Button Text font size
    btnNewPatient.TextSettings.Font.Size := 12;
    btnNewAppointment.TextSettings.Font.Size := 12;
    btnReportAnIssue.TextSettings.Font.Size := 12;
  end;
end;

{ Card Resize }
procedure TfDashboard.CardsResize;
var
  AvailableWidth: Integer;
  ItemsPerRow: Integer;
begin
  AvailableWidth := Trunc(glytCards.Width);

  // Device Dimension setter
  if frmMain.Width > 1900 then   // Dimension greater than 1900
  begin
    glytCards.Width := 1660;
  end
  else
  begin
    glytCards.Width := 270;
  end;

  // Client Dimension condition
  if (frmMain.ClientWidth > 1900) AND not (frmMain.ClientWidth < 900) then
  begin
    ItemsPerRow := Max(1, AvailableWidth div 500);
    glytCards.ItemWidth := Trunc((AvailableWidth - (ItemsPerRow + 1) * 4) / ItemsPerRow);
  end
  else if (frmMain.ClientWidth > 900) AND not (frmMain.ClientWidth < 850) then
  begin
    ItemsPerRow := Max(1, AvailableWidth div 270);
    glytCards.ItemWidth := Trunc((AvailableWidth - (ItemsPerRow + 1) * 4 + 4) / ItemsPerRow);
  end
  else if (frmMain.ClientWidth <= 850) then
  begin
    ItemsPerRow := Max(1, AvailableWidth div 240);
    glytCards.ItemWidth := Trunc((AvailableWidth - (ItemsPerRow + 1) * 4) / ItemsPerRow);
  end;

  // Frame Dimension condition
  if Self.Width >= 1278 then
  begin
    ItemsPerRow := Max(1, AvailableWidth div 410);
    glytCards.ItemWidth := Trunc((AvailableWidth - (ItemsPerRow + 1) * 4 + 6) / ItemsPerRow);
  end
  else if Self.Width >= 1084 then
  begin
    ItemsPerRow := Max(1, AvailableWidth div 265);
    glytCards.ItemWidth := Trunc((AvailableWidth - (ItemsPerRow + 1) * 4 + 8) / ItemsPerRow);
  end
  else if (Self.Width <= 569) OR (glytCards.Width >= 763) then
  begin
    ItemsPerRow := Max(1, AvailableWidth div 245);
    glytCards.ItemWidth := Trunc((AvailableWidth - (ItemsPerRow + 1) * 4) / ItemsPerRow);
  end;
end;

end.
