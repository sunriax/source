
	partial class Form1
	{
		/// <summary>
		/// Erforderliche Designervariable.
		/// </summary>
		private System.ComponentModel.IContainer components = null;

		/// <summary>
		/// Verwendete Ressourcen bereinigen.
		/// </summary>
		/// <param name="disposing">True, wenn verwaltete Ressourcen gelöscht werden sollen; andernfalls False.</param>
		protected override void Dispose(bool disposing)
		{
			if (disposing && (components != null))
			{
				components.Dispose();
			}
			base.Dispose(disposing);
		}

		#region Vom Windows Form-Designer generierter Code

		/// <summary>
		/// Erforderliche Methode für die Designerunterstützung.
		/// Der Inhalt der Methode darf nicht mit dem Code-Editor geändert werden.
		/// </summary>
		private void InitializeComponent()
		{
			this.groupBoxM = new System.Windows.Forms.GroupBox();
			this.buttonColor = new System.Windows.Forms.Button();
			this.textBoxText = new System.Windows.Forms.TextBox();
			this.buttonDo = new System.Windows.Forms.Button();
			this.checkBoxGraph = new System.Windows.Forms.CheckBox();
			this.textBoxData = new System.Windows.Forms.TextBox();
			this.textBoxUnit = new System.Windows.Forms.TextBox();
			this.labelMax = new System.Windows.Forms.Label();
			this.numericUpDownMax = new System.Windows.Forms.NumericUpDown();
			this.labelMin = new System.Windows.Forms.Label();
			this.numericUpDownMin = new System.Windows.Forms.NumericUpDown();
			this.pictureBoxDraw = new System.Windows.Forms.PictureBox();
			this.colorDialogDevice = new System.Windows.Forms.ColorDialog();
			this.groupBoxM.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)(this.numericUpDownMax)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.numericUpDownMin)).BeginInit();
			((System.ComponentModel.ISupportInitialize)(this.pictureBoxDraw)).BeginInit();
			this.SuspendLayout();
			// 
			// groupBoxM
			// 
			this.groupBoxM.Controls.Add(this.buttonColor);
			this.groupBoxM.Controls.Add(this.textBoxText);
			this.groupBoxM.Controls.Add(this.buttonDo);
			this.groupBoxM.Controls.Add(this.checkBoxGraph);
			this.groupBoxM.Controls.Add(this.textBoxData);
			this.groupBoxM.Controls.Add(this.textBoxUnit);
			this.groupBoxM.Controls.Add(this.labelMax);
			this.groupBoxM.Controls.Add(this.numericUpDownMax);
			this.groupBoxM.Controls.Add(this.labelMin);
			this.groupBoxM.Controls.Add(this.numericUpDownMin);
			this.groupBoxM.Location = new System.Drawing.Point(13, 13);
			this.groupBoxM.Name = "groupBoxM";
			this.groupBoxM.Size = new System.Drawing.Size(600, 51);
			this.groupBoxM.TabIndex = 0;
			this.groupBoxM.TabStop = false;
			this.groupBoxM.Text = "Einstellungen";
			// 
			// buttonColor
			// 
			this.buttonColor.BackColor = System.Drawing.Color.Lime;
			this.buttonColor.Cursor = System.Windows.Forms.Cursors.Cross;
			this.buttonColor.Location = new System.Drawing.Point(247, 17);
			this.buttonColor.Name = "buttonColor";
			this.buttonColor.Size = new System.Drawing.Size(46, 23);
			this.buttonColor.TabIndex = 9;
			this.buttonColor.Text = "Farbe";
			this.buttonColor.UseVisualStyleBackColor = false;
			this.buttonColor.Click += new System.EventHandler(this.buttonColor_Click);
			// 
			// textBoxText
			// 
			this.textBoxText.Location = new System.Drawing.Point(141, 19);
			this.textBoxText.Name = "textBoxText";
			this.textBoxText.Size = new System.Drawing.Size(100, 20);
			this.textBoxText.TabIndex = 8;
			this.textBoxText.Text = "Beschreibung";
			this.textBoxText.Enter += new System.EventHandler(this.textBoxText_Enter);
			// 
			// buttonDo
			// 
			this.buttonDo.Location = new System.Drawing.Point(449, 19);
			this.buttonDo.Name = "buttonDo";
			this.buttonDo.Size = new System.Drawing.Size(83, 23);
			this.buttonDo.TabIndex = 7;
			this.buttonDo.Text = "Ausführen";
			this.buttonDo.UseVisualStyleBackColor = true;
			this.buttonDo.Click += new System.EventHandler(this.buttonDo_Click);
			// 
			// checkBoxGraph
			// 
			this.checkBoxGraph.AutoSize = true;
			this.checkBoxGraph.Location = new System.Drawing.Point(538, 23);
			this.checkBoxGraph.Name = "checkBoxGraph";
			this.checkBoxGraph.Size = new System.Drawing.Size(59, 17);
			this.checkBoxGraph.TabIndex = 6;
			this.checkBoxGraph.Text = "Analog";
			this.checkBoxGraph.UseVisualStyleBackColor = true;
			// 
			// textBoxData
			// 
			this.textBoxData.Location = new System.Drawing.Point(10, 19);
			this.textBoxData.Name = "textBoxData";
			this.textBoxData.Size = new System.Drawing.Size(70, 20);
			this.textBoxData.TabIndex = 5;
			this.textBoxData.Text = "Messwert";
			this.textBoxData.Enter += new System.EventHandler(this.textBoxData_Enter);
			// 
			// textBoxUnit
			// 
			this.textBoxUnit.Location = new System.Drawing.Point(85, 19);
			this.textBoxUnit.Name = "textBoxUnit";
			this.textBoxUnit.Size = new System.Drawing.Size(50, 20);
			this.textBoxUnit.TabIndex = 4;
			this.textBoxUnit.Text = "Einheit";
			this.textBoxUnit.Enter += new System.EventHandler(this.textBoxUnit_Enter);
			// 
			// labelMax
			// 
			this.labelMax.AutoSize = true;
			this.labelMax.Location = new System.Drawing.Point(370, 22);
			this.labelMax.Name = "labelMax";
			this.labelMax.Size = new System.Drawing.Size(27, 13);
			this.labelMax.TabIndex = 3;
			this.labelMax.Text = "Max";
			// 
			// numericUpDownMax
			// 
			this.numericUpDownMax.Location = new System.Drawing.Point(403, 19);
			this.numericUpDownMax.Minimum = new decimal(new int[] {
            100,
            0,
            0,
            -2147483648});
			this.numericUpDownMax.Name = "numericUpDownMax";
			this.numericUpDownMax.Size = new System.Drawing.Size(40, 20);
			this.numericUpDownMax.TabIndex = 2;
			// 
			// labelMin
			// 
			this.labelMin.AutoSize = true;
			this.labelMin.Location = new System.Drawing.Point(294, 22);
			this.labelMin.Name = "labelMin";
			this.labelMin.Size = new System.Drawing.Size(24, 13);
			this.labelMin.TabIndex = 1;
			this.labelMin.Text = "Min";
			// 
			// numericUpDownMin
			// 
			this.numericUpDownMin.Location = new System.Drawing.Point(324, 19);
			this.numericUpDownMin.Minimum = new decimal(new int[] {
            100,
            0,
            0,
            -2147483648});
			this.numericUpDownMin.Name = "numericUpDownMin";
			this.numericUpDownMin.Size = new System.Drawing.Size(40, 20);
			this.numericUpDownMin.TabIndex = 0;
			// 
			// pictureBoxDraw
			// 
			this.pictureBoxDraw.BackColor = System.Drawing.Color.White;
			this.pictureBoxDraw.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			this.pictureBoxDraw.Location = new System.Drawing.Point(13, 71);
			this.pictureBoxDraw.Name = "pictureBoxDraw";
			this.pictureBoxDraw.Size = new System.Drawing.Size(600, 360);
			this.pictureBoxDraw.TabIndex = 1;
			this.pictureBoxDraw.TabStop = false;
			this.pictureBoxDraw.Paint += new System.Windows.Forms.PaintEventHandler(this.pictureBoxPaint_Paint);
			this.pictureBoxDraw.MouseClick += new System.Windows.Forms.MouseEventHandler(this.pictureBoxPaint_MouseClick);
			this.pictureBoxDraw.MouseMove += new System.Windows.Forms.MouseEventHandler(this.pictureBoxPaint_MouseMove);
			// 
			// Form1
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(624, 441);
			this.Controls.Add(this.pictureBoxDraw);
			this.Controls.Add(this.groupBoxM);
			this.Name = "Form1";
			this.Text = "Messgerät";
			this.groupBoxM.ResumeLayout(false);
			this.groupBoxM.PerformLayout();
			((System.ComponentModel.ISupportInitialize)(this.numericUpDownMax)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.numericUpDownMin)).EndInit();
			((System.ComponentModel.ISupportInitialize)(this.pictureBoxDraw)).EndInit();
			this.ResumeLayout(false);

		}

		#endregion

		private System.Windows.Forms.GroupBox groupBoxM;
		private System.Windows.Forms.TextBox textBoxUnit;
		private System.Windows.Forms.Label labelMax;
		private System.Windows.Forms.NumericUpDown numericUpDownMax;
		private System.Windows.Forms.Label labelMin;
		private System.Windows.Forms.NumericUpDown numericUpDownMin;
		private System.Windows.Forms.Button buttonDo;
		private System.Windows.Forms.CheckBox checkBoxGraph;
		private System.Windows.Forms.TextBox textBoxData;
		private System.Windows.Forms.PictureBox pictureBoxDraw;
		private System.Windows.Forms.TextBox textBoxText;
		private System.Windows.Forms.Button buttonColor;
		private System.Windows.Forms.ColorDialog colorDialogDevice;
	}
