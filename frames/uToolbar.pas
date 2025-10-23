unit uToolbar;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  System.Skia, FMX.Controls.Presentation, FMX.Ani, FMX.Objects, FMX.Skia,
  FMX.ImgList, FMX.Layouts, FMX.MultiView, FMX.DialogService, Data.DB;

type
  TfToolbar = class(TFrame)
    rToolbar: TRectangle;
    lBevel: TLine;
    lytToolbarH: TLayout;
    gDateIcon: TGlyph;
    lytUser: TLayout;
    slUserName: TSkLabel;
    rUserImage: TRoundRect;
    rPopUp: TRectangle;
    FloatAnimation4: TFloatAnimation;
    lDate: TLabel;
    mvPopUp: TMultiView;
    cbAccountSettings: TCornerButton;
    cbLogout: TCornerButton;
    lDivider: TLine;
    gIcon: TGlyph;
    procedure cbAccountSettingsClick(Sender: TObject);
    procedure cbLogoutClick(Sender: TObject);
    procedure FramePainting(Sender: TObject; Canvas: TCanvas;
      const ARect: TRectF);
  private
    { Private declarations }
  public
    procedure ProfileSetter;
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uMain, uLogin, uDm;

{ Set Profile pic }
procedure TfToolbar.ProfileSetter;
  var
  ms: TMemoryStream;
begin
  dm.qUsers.Open; // Open users query

  // Get Profile Photo
  // Load Profile Photo (LONGBLOB -> TImage)
  rUserImage.Fill.Kind := TBrushKind.Bitmap;
  ms := TMemoryStream.Create;
  try
    if not dm.qUsers.FieldByName('profile_pic').IsNull then
    begin
      TBlobField(dm.qUsers.FieldByName('profile_pic')).SaveToStream(ms);
      ms.Position := 0;
      rUserImage.Fill.Bitmap.Bitmap.LoadFromStream(ms);
      gIcon.ImageIndex := -1; // Hide Icon
    end
    else
    begin
      rUserImage.Fill.Bitmap.Bitmap := nil; // Clear if no photo
      rUserImage.Fill.Kind := TBrushKind.Solid; // Set color background
      gIcon.ImageIndex := 10; // Show Icon
    end;
  finally
    rUserImage.Fill.Bitmap.WrapMode := TWrapMode.TileStretch;
    ms.Free;
  end;

  dm.qUsers.Close;  // Close users query
end;

{ Account Settings }
procedure TfToolbar.cbAccountSettingsClick(Sender: TObject);
begin
  // Hide frames
  frmMain.HideFrames;

  // Reset Button Focus
  frmMain.ButtonPressedReset;

  // Switch tab index
  frmMain.tcController.TabIndex := 4;
  frmMain.fUserProfile.Visible := True;
  frmMain.fUserProfile.ScrollBox1.ViewportPosition := PointF(0,0); // reset scrollbox
end;

{ Logout }
procedure TfToolbar.cbLogoutClick(Sender: TObject);
begin
  TDialogService.MessageDialog(
    'Are you sure you want to logout?',
    TMsgDlgType.mtInformation,            // info icon
    [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],  // Yes + Cancel buttons
    TMsgDlgBtn.mbNo,                      // Default button
    0,                                    // Help context
    procedure(const AResult: TModalResult)
    begin
      if AResult = mrYes then
      begin
        frmMain.Free;
        frmMain := nil;
        frmLogin.Show;
      end;
      // If Cancel pressed, do nothing
    end
  );
end;

{ Frame Painting }
procedure TfToolbar.FramePainting(Sender: TObject; Canvas: TCanvas;
  const ARect: TRectF);
begin
  slUserName.Words.Items[0].Text := dm.User.UsernameH + ''; // Set the username
  slUserName.Words.Items[1].Text := dm.User.RoleH; // set the role of the user
end;

end.
