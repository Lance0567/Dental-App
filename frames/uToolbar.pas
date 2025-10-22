unit uToolbar;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  System.Skia, FMX.Controls.Presentation, FMX.Ani, FMX.Objects, FMX.Skia,
  FMX.ImgList, FMX.Layouts, FMX.MultiView, FMX.DialogService;

type
  TfToolbar = class(TFrame)
    rToolbar: TRectangle;
    lBevel: TLine;
    lytToolbarH: TLayout;
    gIcon: TGlyph;
    lytUser: TLayout;
    slUserName: TSkLabel;
    rrUserImage: TRoundRect;
    rPopUp: TRectangle;
    FloatAnimation4: TFloatAnimation;
    lDate: TLabel;
    mvPopUp: TMultiView;
    cbAccountSettings: TCornerButton;
    cbLogout: TCornerButton;
    lDivider: TLine;
    procedure cbAccountSettingsClick(Sender: TObject);
    procedure cbLogoutClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uMain, uLogin;

{ Account Settings }
procedure TfToolbar.cbAccountSettingsClick(Sender: TObject);
begin
  frmMain.tcController.TabIndex := 4;
end;

{ Logout }
procedure TfToolbar.cbLogoutClick(Sender: TObject);
begin
  TDialogService.MessageDialog(
    'Are you sure you want to logout?',
    TMsgDlgType.mtWarning,                  // warning icon
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbCancel],// Yes + Cancel buttons
    TMsgDlgBtn.mbCancel,                    // Default button
    0,                                      // Help context
    procedure(const AResult: TModalResult)
    begin
      if AResult = mrYes then
      begin
        frmMain.Hide;
        frmLogin.Show;
      end;
      // If Cancel pressed, do nothing
    end
  );
end;


end.
