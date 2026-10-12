"use client";

import { useEffect, useRef } from "react";
import * as THREE from "three";

export default function ThreeScrollFollowerEye() {
  const containerRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const container = containerRef.current;
    if (!container) return;

    // 1. Scene, Camera, Renderer
    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(
      45,
      window.innerWidth / window.innerHeight,
      0.1,
      1000
    );
    camera.position.z = 8;

    const renderer = new THREE.WebGLRenderer({ alpha: true, antialias: true });
    renderer.setSize(window.innerWidth, window.innerHeight);
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
    container.appendChild(renderer.domElement);

    // Group containing the entire floating 3D Byakugan Core
    const eyeSystem = new THREE.Group();
    scene.add(eyeSystem);

    // Initial position (Hero mode: offset slightly to the right on desktop)
    eyeSystem.position.set(2.2, 0, 0);

    // 2. Central Byakugan Core (Pale Lavender-White Glowing Iris)
    const irisGeo = new THREE.SphereGeometry(1.0, 64, 64);
    const irisMat = new THREE.MeshStandardMaterial({
      color: 0xf5f3ff, // ethereal pale lavender/white
      roughness: 0.15,
      metalness: 0.2,
      emissive: 0xa78bfa,
      emissiveIntensity: 0.45,
    });
    const iris = new THREE.Mesh(irisGeo, irisMat);
    eyeSystem.add(iris);

    // Signature Byakugan concentric inner iris ring (No pupil)
    const pupilRingGeo = new THREE.TorusGeometry(0.55, 0.02, 16, 64);
    const pupilRingMat = new THREE.MeshBasicMaterial({ color: 0x818cf8 });
    const pupilRing = new THREE.Mesh(pupilRingGeo, pupilRingMat);
    eyeSystem.add(pupilRing);

    // 3. Holographic Concentric Scanning Reticle Rings
    const rings: THREE.Mesh[] = [];
    const ringConfigs = [
      { radius: 1.45, color: 0x818cf8, rotX: 0.2, rotY: 0.1, speed: 0.008 },
      { radius: 1.85, color: 0x38bdf8, rotX: -0.3, rotY: 0.25, speed: -0.006 },
      { radius: 2.25, color: 0xc084fc, rotX: 0.15, rotY: -0.2, speed: 0.005 },
      { radius: 2.7, color: 0x60a5fa, rotX: -0.25, rotY: 0.1, speed: -0.004 },
    ];

    ringConfigs.forEach((cfg) => {
      const geo = new THREE.TorusGeometry(cfg.radius, 0.012, 16, 80);
      const mat = new THREE.MeshBasicMaterial({
        color: cfg.color,
        transparent: true,
        opacity: 0.65,
      });
      const ring = new THREE.Mesh(geo, mat);
      ring.rotation.x = cfg.rotX;
      ring.rotation.y = cfg.rotY;
      eyeSystem.add(ring);
      rings.push(ring);
    });

    // 4. Coordinate Reticle Ticks around the perimeter
    const tickGroup = new THREE.Group();
    for (let i = 0; i < 32; i++) {
      const angle = (i / 32) * Math.PI * 2;
      const isMajor = i % 4 === 0;
      const rInner = 2.15;
      const rOuter = isMajor ? 2.35 : 2.25;
      const tickGeo = new THREE.BufferGeometry().setFromPoints([
        new THREE.Vector3(Math.cos(angle) * rInner, Math.sin(angle) * rInner, 0),
        new THREE.Vector3(Math.cos(angle) * rOuter, Math.sin(angle) * rOuter, 0),
      ]);
      const tickMat = new THREE.LineBasicMaterial({
        color: isMajor ? 0x38bdf8 : 0x818cf8,
        transparent: true,
        opacity: isMajor ? 0.8 : 0.4,
      });
      const tick = new THREE.Line(tickGeo, tickMat);
      tickGroup.add(tick);
    }
    eyeSystem.add(tickGroup);

    // 5. Vein Activation Branches (Manga Byakugan Jutsu Chakra Veins)
    const veinGroup = new THREE.Group();
    for (let i = 0; i < 8; i++) {
      const angle = (i / 8) * Math.PI * 2 + 0.2;
      const points: THREE.Vector3[] = [];
      const baseR = 1.0;
      for (let j = 0; j <= 5; j++) {
        const r = baseR + j * 0.35;
        const wiggle = (Math.random() - 0.5) * 0.2;
        points.push(
          new THREE.Vector3(
            Math.cos(angle + wiggle) * r,
            Math.sin(angle + wiggle) * r,
            (Math.random() - 0.5) * 0.15
          )
        );
      }
      const curve = new THREE.CatmullRomCurve3(points);
      const veinGeo = new THREE.TubeGeometry(curve, 20, 0.015, 8, false);
      const veinMat = new THREE.MeshBasicMaterial({
        color: 0x60a5fa,
        transparent: true,
        opacity: 0.55,
      });
      const veinMesh = new THREE.Mesh(veinGeo, veinMat);
      veinGroup.add(veinMesh);
    }
    eyeSystem.add(veinGroup);

    // 6. Floating Chakra Particle Swarm
    const particleCount = 240;
    const particleGeo = new THREE.BufferGeometry();
    const particlePos = new Float32Array(particleCount * 3);

    for (let i = 0; i < particleCount * 3; i += 3) {
      const theta = Math.random() * Math.PI * 2;
      const phi = Math.acos(Math.random() * 2 - 1);
      const r = 1.8 + Math.random() * 2.5;
      particlePos[i] = r * Math.sin(phi) * Math.cos(theta);
      particlePos[i + 1] = r * Math.sin(phi) * Math.sin(theta);
      particlePos[i + 2] = r * Math.cos(phi);
    }
    particleGeo.setAttribute("position", new THREE.BufferAttribute(particlePos, 3));

    const particleMat = new THREE.PointsMaterial({
      color: 0xc4b5fd,
      size: 0.045,
      transparent: true,
      opacity: 0.7,
      blending: THREE.AdditiveBlending,
    });
    const particles = new THREE.Points(particleGeo, particleMat);
    eyeSystem.add(particles);

    // 7. Lighting Setup
    const ambient = new THREE.AmbientLight(0xffffff, 0.9);
    scene.add(ambient);

    const pointLight = new THREE.PointLight(0xa78bfa, 3, 15);
    pointLight.position.set(3, 4, 5);
    scene.add(pointLight);

    const cyanLight = new THREE.PointLight(0x38bdf8, 2.5, 12);
    cyanLight.position.set(-3, -3, -2);
    scene.add(cyanLight);

    // 8. SCROLL & MOUSE DYNAMICS
    let scrollProgress = 0;
    let targetX = 2.2;
    let targetY = 0;
    let targetZ = 0;
    let targetScale = 1;
    let mouseX = 0;
    let mouseY = 0;

    const handleScroll = () => {
      const maxScroll = document.documentElement.scrollHeight - window.innerHeight;
      scrollProgress = maxScroll > 0 ? window.scrollY / maxScroll : 0;

      // Choreograph 3D eye path through sections:
      // Section 1 (Hero - 0 to 0.2): Centered slightly to the right on desktop
      // Section 2 (Manga Lore - 0.2 to 0.4): Moves to left side, scales up
      // Section 3 (Neural HUD - 0.4 to 0.65): Centers in background, pulses like a laser
      // Section 4 (Specs - 0.65 to 0.85): Moves to right side, tilts dynamically
      // Section 5 (CTA Finale - 0.85 to 1.0): Drifts to center-top as radiant eye
      const isMobile = window.innerWidth < 768;

      if (isMobile) {
        // Mobile layout: keep centered with subtle depth shifts
        targetX = 0;
        targetY = 0.5 - scrollProgress * 0.8;
        targetZ = -1.5;
        targetScale = 0.65;
      } else {
        if (scrollProgress < 0.22) {
          // Hero
          const p = scrollProgress / 0.22;
          targetX = THREE.MathUtils.lerp(2.2, 1.8, p);
          targetY = THREE.MathUtils.lerp(0, -0.4, p);
          targetZ = 0;
          targetScale = THREE.MathUtils.lerp(1, 0.9, p);
        } else if (scrollProgress < 0.48) {
          // Lore Section (shift left so content on right is clear)
          const p = (scrollProgress - 0.22) / 0.26;
          targetX = THREE.MathUtils.lerp(1.8, -2.6, p);
          targetY = THREE.MathUtils.lerp(-0.4, 0.2, p);
          targetZ = THREE.MathUtils.lerp(0, 0.5, p);
          targetScale = THREE.MathUtils.lerp(0.9, 1.15, p);
        } else if (scrollProgress < 0.72) {
          // Simulator HUD (move behind demo canvas)
          const p = (scrollProgress - 0.48) / 0.24;
          targetX = THREE.MathUtils.lerp(-2.6, 2.5, p);
          targetY = THREE.MathUtils.lerp(0.2, -0.1, p);
          targetZ = THREE.MathUtils.lerp(0.5, -0.5, p);
          targetScale = THREE.MathUtils.lerp(1.15, 0.85, p);
        } else {
          // Finale
          const p = (scrollProgress - 0.72) / 0.28;
          targetX = THREE.MathUtils.lerp(2.5, 0, p);
          targetY = THREE.MathUtils.lerp(-0.1, 1.2, p);
          targetZ = THREE.MathUtils.lerp(-0.5, -0.2, p);
          targetScale = THREE.MathUtils.lerp(0.85, 1.2, p);
        }
      }
    };

    const handleMouseMove = (e: MouseEvent) => {
      mouseX = (e.clientX / window.innerWidth) * 2 - 1;
      mouseY = -(e.clientY / window.innerHeight) * 2 + 1;
    };

    const handleResize = () => {
      camera.aspect = window.innerWidth / window.innerHeight;
      camera.updateProjectionMatrix();
      renderer.setSize(window.innerWidth, window.innerHeight);
      handleScroll();
    };

    window.addEventListener("scroll", handleScroll, { passive: true });
    window.addEventListener("mousemove", handleMouseMove, { passive: true });
    window.addEventListener("resize", handleResize);

    // Initial positioning
    handleScroll();

    // 9. ANIMATION LOOP
    let animationId: number;
    const clock = new THREE.Clock();

    const animate = () => {
      animationId = requestAnimationFrame(animate);
      const time = clock.getElapsedTime();

      // Smooth position interpolation
      eyeSystem.position.x += (targetX - eyeSystem.position.x) * 0.05;
      eyeSystem.position.y += (targetY - eyeSystem.position.y) * 0.05;
      eyeSystem.position.z += (targetZ - eyeSystem.position.z) * 0.05;

      // Scale smoothly
      const currentScale = eyeSystem.scale.x;
      const nextScale = currentScale + (targetScale - currentScale) * 0.05;
      eyeSystem.scale.set(nextScale, nextScale, nextScale);

      // Track cursor gaze slightly
      const targetRotY = mouseX * 0.35 + scrollProgress * Math.PI * 1.5;
      const targetRotX = -mouseY * 0.25;
      eyeSystem.rotation.y += (targetRotY - eyeSystem.rotation.y) * 0.04;
      eyeSystem.rotation.x += (targetRotX - eyeSystem.rotation.x) * 0.04;

      // Rotate reticle rings
      rings.forEach((ring, idx) => {
        const dir = idx % 2 === 0 ? 1 : -1;
        ring.rotation.z += 0.005 * dir;
      });

      tickGroup.rotation.z -= 0.003;
      particles.rotation.y += 0.001;
      veinGroup.rotation.z += 0.0015;

      // Heartbeat pulse of chakra
      const pulse = 1 + Math.sin(time * 2.5) * 0.025;
      iris.scale.set(pulse, pulse, pulse);

      renderer.render(scene, camera);
    };

    animate();

    return () => {
      cancelAnimationFrame(animationId);
      window.removeEventListener("scroll", handleScroll);
      window.removeEventListener("mousemove", handleMouseMove);
      window.removeEventListener("resize", handleResize);
      renderer.dispose();
      if (container.contains(renderer.domElement)) {
        container.removeChild(renderer.domElement);
      }
    };
  }, []);

  return (
    <div
      ref={containerRef}
      className="fixed inset-0 pointer-events-none z-10 overflow-hidden"
      aria-hidden="true"
    />
  );
}
