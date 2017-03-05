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
			this.groupBoxItem = new System.Windows.Forms.GroupBox();
			this.radioButtonC = new System.Windows.Forms.RadioButton();
			this.radioButtonL = new System.Windows.Forms.RadioButton();
			this.radioButtonR = new System.Windows.Forms.RadioButton();
			this.pictureBoxDraw = new System.Windows.Forms.PictureBox();
			this.textBoxText = new System.Windows.Forms.TextBox();
			this.buttonStart = new System.Windows.Forms.Button();
			this.groupBoxItem.SuspendLayout();
			((System.ComponentModel.ISupportInitialize)(this.pictureBoxDraw)).BeginInit();
			this.SuspendLayout();
			// 
			// groupBoxItem
			// 
			this.groupBoxItem.Controls.Add(this.buttonStart);
			this.groupBoxItem.Controls.Add(this.textBoxText);
			this.groupBoxItem.Controls.Add(this.radioButtonC);
			this.groupBoxItem.Controls.Add(this.radioButtonL);
			this.groupBoxItem.Controls.Add(this.radioButtonR);
			this.groupBoxItem.Font = new System.Drawing.Font("Lucida Console", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.groupBoxItem.Location = new System.Drawing.Point(13, 13);
			this.groupBoxItem.Name = "groupBoxItem";
			this.groupBoxItem.Size = new System.Drawing.Size(600, 46);
			this.groupBoxItem.TabIndex = 0;
			this.groupBoxItem.TabStop = false;
			this.groupBoxItem.Text = "Bauteile";
			// 
			// radioButtonC
			// 
			this.radioButtonC.AutoSize = true;
			this.radioButtonC.Font = new System.Drawing.Font("Lucida Console", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.radioButtonC.Location = new System.Drawing.Point(275, 20);
			this.radioButtonC.Name = "radioButtonC";
			this.radioButtonC.Size = new System.Drawing.Size(128, 16);
			this.radioButtonC.TabIndex = 2;
			this.radioButtonC.TabStop = true;
			this.radioButtonC.Text = "(C) Kondensator";
			this.radioButtonC.UseVisualStyleBackColor = true;
			// 
			// radioButtonL
			// 
			this.radioButtonL.AutoSize = true;
			this.radioButtonL.Font = new System.Drawing.Font("Lucida Console", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.radioButtonL.Location = new System.Drawing.Point(134, 20);
			this.radioButtonL.Name = "radioButtonL";
			this.radioButtonL.Size = new System.Drawing.Size(135, 16);
			this.radioButtonL.TabIndex = 1;
			this.radioButtonL.TabStop = true;
			this.radioButtonL.Text = "(L) Induktivität";
			this.radioButtonL.UseVisualStyleBackColor = true;
			// 
			// radioButtonR
			// 
			this.radioButtonR.AutoSize = true;
			this.radioButtonR.Checked = true;
			this.radioButtonR.Font = new System.Drawing.Font("Lucida Console", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.radioButtonR.Location = new System.Drawing.Point(7, 20);
			this.radioButtonR.Name = "radioButtonR";
			this.radioButtonR.Size = new System.Drawing.Size(121, 16);
			this.radioButtonR.TabIndex = 0;
			this.radioButtonR.TabStop = true;
			this.radioButtonR.Text = "(R) Widerstand";
			this.radioButtonR.UseVisualStyleBackColor = true;
			// 
			// pictureBoxDraw
			// 
			this.pictureBoxDraw.BackColor = System.Drawing.Color.White;
			this.pictureBoxDraw.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
			this.pictureBoxDraw.Location = new System.Drawing.Point(13, 65);
			this.pictureBoxDraw.Name = "pictureBoxDraw";
			this.pictureBoxDraw.Size = new System.Drawing.Size(600, 365);
			this.pictureBoxDraw.TabIndex = 1;
			this.pictureBoxDraw.TabStop = false;
			this.pictureBoxDraw.Paint += new System.Windows.Forms.PaintEventHandler(this.pictureBoxDraw_Paint);
			this.pictureBoxDraw.MouseClick += new System.Windows.Forms.MouseEventHandler(this.pictureBoxDraw_MouseClick);
			this.pictureBoxDraw.MouseMove += new System.Windows.Forms.MouseEventHandler(this.pictureBoxDraw_MouseMove);
			// 
			// textBoxText
			// 
			this.textBoxText.Font = new System.Drawing.Font("Verdana", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.textBoxText.Location = new System.Drawing.Point(409, 16);
			this.textBoxText.Multiline = true;
			this.textBoxText.Name = "textBoxText";
			this.textBoxText.Size = new System.Drawing.Size(100, 20);
			this.textBoxText.TabIndex = 3;
			this.textBoxText.Text = "Bezeichnung";
			this.textBoxText.Enter += new System.EventHandler(this.textBoxText_Enter);
			// 
			// buttonStart
			// 
			this.buttonStart.Font = new System.Drawing.Font("Lucida Console", 9.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
			this.buttonStart.Location = new System.Drawing.Point(516, 16);
			this.buttonStart.Name = "buttonStart";
			this.buttonStart.Size = new System.Drawing.Size(78, 20);
			this.buttonStart.TabIndex = 4;
			this.buttonStart.Text = "Start";
			this.buttonStart.UseVisualStyleBackColor = true;
			this.buttonStart.Click += new System.EventHandler(this.buttonStart_Click);
			// 
			// Form1
			// 
			this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
			this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
			this.ClientSize = new System.Drawing.Size(624, 441);
			this.Controls.Add(this.pictureBoxDraw);
			this.Controls.Add(this.groupBoxItem);
			this.Name = "Form1";
			this.Text = "drawRLC";
			this.groupBoxItem.ResumeLayout(false);
			this.groupBoxItem.PerformLayout();
			((System.ComponentModel.ISupportInitialize)(this.pictureBoxDraw)).EndInit();
			this.ResumeLayout(false);

		}

		#endregion

		private System.Windows.Forms.GroupBox groupBoxItem;
		private System.Windows.Forms.RadioButton radioButtonC;
		private System.Windows.Forms.RadioButton radioButtonL;
		private System.Windows.Forms.RadioButton radioButtonR;
		private System.Windows.Forms.PictureBox pictureBoxDraw;
		private System.Windows.Forms.Button buttonStart;
		private System.Windows.Forms.TextBox textBoxText;
	}

