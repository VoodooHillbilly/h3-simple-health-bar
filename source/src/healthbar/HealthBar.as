package healthbar {
import common.BaseControl;

import flash.events.Event;

import flash.geom.ColorTransform;

public class HealthBar extends BaseControl {

	private var m_healthBarView:HealthBarView = new HealthBarView();
	private var m_currentHealth:Number;
	private var m_isInfected:Boolean = false;
	private var m_lowHealthColour:uint;
	private var m_mediumHealthColour:uint;
	private var m_fullHealthColour:uint;
	private var m_infectedColour:uint;
	private var m_DebugMode:Boolean;

	public function HealthBar() {
		m_healthBarView.DebugText.visible = false;
		addChild(m_healthBarView);
	}

	public function SetHealth(health:Number):void {
		m_currentHealth = health;
		m_healthBarView.HealthBarText.text = String(Math.round(health));
		UpdateHealth()
	}

	public function SetInfected(isInfected:Boolean):void {
		m_isInfected = isInfected;

		if (isInfected) {
			m_healthBarView.HealthBarInner.gotoAndPlay(2);
		} else {
			m_healthBarView.HealthBarInner.gotoAndPlay(1);
		}

		UpdateHealthBarColour();
	}

	private function UpdateHealth():void {
		var m_maxHealth:Number = 100;
		m_healthBarView.HealthBarInner.scaleY = m_currentHealth / m_maxHealth;
		UpdateHealthBarColour();
	}

	private function UpdateHealthBarColour():void {
		if (m_isInfected) {
			var yellow:ColorTransform = new ColorTransform();
			yellow.color = m_infectedColour;
			m_healthBarView.HealthBarInner.transform.colorTransform = yellow;
			return;
		}

		var m_maxHealth:Number = 100;
		var healthRatio:Number = m_currentHealth / m_maxHealth;

		var mediumHealthRatio:Number = 0.5;

		var low:uint, medium:uint, full:uint;

		if (healthRatio <= mediumHealthRatio) {
			var lowToMiddleRatio:Number = healthRatio / mediumHealthRatio;
			low = interpolate((m_lowHealthColour >> 16) & 0xFF, (m_mediumHealthColour >> 16) & 0xFF, lowToMiddleRatio);
			full = interpolate((m_lowHealthColour >> 8) & 0xFF, (m_mediumHealthColour >> 8) & 0xFF, lowToMiddleRatio);
			medium = interpolate(m_lowHealthColour & 0xFF, m_mediumHealthColour & 0xFF, lowToMiddleRatio);
		} else {
			var middleToFullRatio:Number = (healthRatio - mediumHealthRatio) / (1 - mediumHealthRatio);
			low = interpolate((m_mediumHealthColour >> 16) & 0xFF, (m_fullHealthColour >> 16) & 0xFF, middleToFullRatio);
			full = interpolate((m_mediumHealthColour >> 8) & 0xFF, (m_fullHealthColour >> 8) & 0xFF, middleToFullRatio);
			medium = interpolate(m_mediumHealthColour & 0xFF, m_fullHealthColour & 0xFF, middleToFullRatio);
		}

		var colorTransform:ColorTransform = new ColorTransform();
		colorTransform.color = (low << 16) | (full << 8) | medium;
		m_healthBarView.HealthBarInner.transform.colorTransform = colorTransform;
	}

	private function interpolate(start:uint, end:uint, ratio:Number):uint {
		return start + (end - start) * ratio;
	}

	private function parseRGB(rgba:String):uint {
		if (rgba.charAt(0) == "#") {
			rgba = rgba.substring(1);
		}

		var colourValue:uint = parseInt(rgba.substr(0, 6), 16);

		return colourValue;
	}

	public function set HealthBarTextColour(colour:String):void {
		var colourValue:uint = parseRGB(colour);
		m_healthBarView.HealthBarText.textColor = colourValue;
	}

	public function set HealthBarTextBGColour(colour:String):void {
		var colourValue:uint = parseRGB(colour);
		var colorTransform:ColorTransform = new ColorTransform();
		colorTransform.color = colourValue;
		m_healthBarView.HealthBarTextBG.transform.colorTransform = colorTransform;
	}

	public function set HealthBarTextBorderColour(colour:String):void {
		var colourValue:uint = parseRGB(colour);
		var colorTransform:ColorTransform = new ColorTransform();
		colorTransform.color = colourValue;
		m_healthBarView.HealthBarTextBorder.transform.colorTransform = colorTransform;
	}

	public function set HealthBarBGColour(colour:String):void {
		var colourValue:uint = parseRGB(colour);
		var colorTransform:ColorTransform = new ColorTransform();
		colorTransform.color = colourValue;
		m_healthBarView.HealthBarBG.transform.colorTransform = colorTransform;
	}

	public function set HealthBarBorderColour(colour:String):void {
		var colourValue:uint = parseRGB(colour);
		var colorTransform:ColorTransform = new ColorTransform();
		colorTransform.color = colourValue;
		m_healthBarView.HealthBarBorder.transform.colorTransform = colorTransform;
	}

	public function set LowHealthColour(colour:String):void {
		var colourValue:uint = parseRGB(colour);
		m_lowHealthColour = colourValue;
	}

	public function set MediumHealthColour(colour:String):void {
		var colourValue:uint = parseRGB(colour);
		m_mediumHealthColour = colourValue;
	}

	public function set FullHealthColour(colour:String):void {
		var colourValue:uint = parseRGB(colour);
		m_fullHealthColour = colourValue;
	}

	public function set InfectedColour(colour:String):void {
		var colourValue:uint = parseRGB(colour);
		m_infectedColour = colourValue;
	}

	public function set Debug(health:Number):void {
		SetHealth(health);
	}

	public function set DebugMode(bool:Boolean):void {
		if (bool) {
			addEventListener(Event.ENTER_FRAME, UpdateDebugText);
			m_healthBarView.DebugText.visible = true;
		}
		else {
			removeEventListener(Event.ENTER_FRAME, UpdateDebugText);
			m_healthBarView.DebugText.visible = false;
		}
	}

	private function UpdateDebugText(e:Event):void {
		var debugInfo:String = "";
		debugInfo += "Current Health: " + Math.round(m_currentHealth) + "\n";
		debugInfo += "Is Infected: " + m_isInfected + "\n";
		debugInfo += "Low Health Red Colour: #" + m_lowHealthColour.toString(16) + "\n";
		debugInfo += "Full Health Green Colour: #" + m_fullHealthColour.toString(16) + "\n";

		m_healthBarView.DebugText.text = debugInfo;
		m_healthBarView.DebugText.visible = true;
		m_healthBarView.DebugText.wordWrap = true;
		m_healthBarView.DebugText.multiline = true;
	}

}
}
