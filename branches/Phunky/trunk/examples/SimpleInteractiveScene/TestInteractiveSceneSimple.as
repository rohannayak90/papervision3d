package {
	
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.scenes.*;
	import org.papervision3d.cameras.*;
	import org.papervision3d.objects.*;
	import org.papervision3d.materials.*;
	import org.papervision3d.utils.*;
	import org.papervision3d.objects.Sphere;
	import org.papervision3d.utils.virtualmouse.VirtualMouse;
	import org.papervision3d.utils.virtualmouse.IVirtualMouseEvent;
	import org.papervision3d.utils.InteractiveSceneManager;

	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.BlendMode;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	[SWF(backgroundColor="0xFFFFFF", frameRate="31")]
	public class TestInteractiveSceneSimple extends Sprite {
		
		protected var container 				:Sprite;
		protected var scene     				:InteractiveScene3D;
		protected var camera   					:Camera3D;
		protected var ism						:InteractiveSceneManager;
		protected var plane	 	 				:Plane;
		protected var vMouse	  				:VirtualMouse;
		
		private var mc							:MovieClip;
		private var child						:MovieClip;
		
		public function TestInteractiveSceneSimple() {
			init();
		}
		public function init():void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			createContent();
			init3D();
			createPlane();
			addEventListener(Event.ENTER_FRAME, loop);
		}
		protected function createContent():void {
	 		mc = new MovieClip();
	 		mc.name = "mc";
			mc.graphics.beginFill( 0xFF3300, 100 );
			mc.graphics.drawRect(0, 0, 200, 200);
			mc.graphics.endFill();
			
	 		child = new MovieClip();
	 		child.name = "child";
			child.graphics.beginFill( 0x0000FF, 100 );
			child.graphics.drawRect(50, 50, 50, 50);
			child.graphics.endFill();
			mc.addChild(child);
		}
		protected function init3D():void {
			container = new InteractiveSprite();
			addChild(container);
			container.name = "mainCont";
			container.x = stage.stageWidth*.5;
			container.y = stage.stageHeight*.5;
	
			scene = new InteractiveScene3D(container);
			ism = scene.interactiveSceneManager;
			
			InteractiveSceneManager.SHOW_DRAWN_FACES = false;
			InteractiveSceneManager.DEFAULT_SPRITE_ALPHA = 0;
			InteractiveSceneManager.DEFAULT_FILL_ALPHA = 1;
			
			BitmapMaterial.AUTO_MIP_MAPPING = false;
			DisplayObject3D.faceLevelMode = false;
			
			ism.buttonMode = true;
			ism.faceLevelMode = true;											
			ism.mouseInteractionMode = false;
			
			camera = new Camera3D();
			camera.zoom = 3;
			camera.focus = 500;
		}
		protected function createPlane():void {
			var material:MovieMaterial = new InteractiveMovieMaterial(mc);
			var mChild:DisplayObject = material.movie.getChildByName("child");
			material.animated = true;
			material.smooth = true;

			material.movie.addEventListener(MouseEvent.MOUSE_OVER, handleMainOver);
			material.movie.addEventListener(MouseEvent.MOUSE_OUT, handleMainOut);
			mChild.addEventListener(MouseEvent.CLICK, handleBTNClick);
			mChild.addEventListener(MouseEvent.MOUSE_OVER, handleBTNOver);
			mChild.addEventListener(MouseEvent.MOUSE_OUT, handleBTNOut);

			material.updateBitmap();
			
			var plane:Plane = new Plane( material, mc.width, mc.height, 8, 8 );
			scene.addChild(plane);
		}
		protected function loop(event:Event):void {
			camera.x = -(container.mouseX * 3)/2;
			camera.y = (container.mouseY * 3);
			scene.renderCamera(camera);
		}
		protected function handleBTNClick(e:MouseEvent):void {
			if (e is IVirtualMouseEvent) trace("IVirtualMouseEvent click from btn");
		}
		protected function handleBTNOver(e:MouseEvent):void {
			e.currentTarget.blendMode = BlendMode.ADD;
		}
		protected function handleBTNOut(e:MouseEvent):void {
			e.currentTarget.blendMode = BlendMode.NORMAL;
		}
		protected function handleMainClick(e:MouseEvent):void {
			trace("vMouse click from btn", e.currentTarget);
			if (e is IVirtualMouseEvent) trace("IVirtualMouseEvent click from btn");
		}
		protected function handleMainOver(e:MouseEvent):void { trace("handleMainOver", e.currentTarget); e.currentTarget.alpha = .8; } 
		protected function handleMainOut(e:MouseEvent):void { trace("handleMainOut", e.currentTarget); e.currentTarget.alpha = 1; }
	}
}


