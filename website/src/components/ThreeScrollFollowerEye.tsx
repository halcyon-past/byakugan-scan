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
    camera.position.z = 7.5;

    const renderer = new THREE.WebGLRenderer({ alpha: true, antialias: true, powerPreference: "high-performance" });
    renderer.setSize(window.innerWidth, window.innerHeight);
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
    renderer.toneMapping = THREE.ACESFilmicToneMapping;
    renderer.toneMappingExposure = 1.25;
    container.appendChild(renderer.domElement);

    // Master System Group (coordinates scroll movement)
    const eyeSystem = new THREE.Group();
    scene.add(eyeSystem);
    eyeSystem.position.set(2.2, 0, 0);

    // Eye Orbit Group (handles lookAt mouse gaze and saccadic eye jitter)
    const eyeOrbitGroup = new THREE.Group();
    eyeSystem.add(eyeOrbitGroup);

    // 2. Texture Loader
    const textureLoader = new THREE.TextureLoader();
    const colorMap = textureLoader.load("/art/byakugan_eyeball_texture.png");
    const normalMap = textureLoader.load("/art/byakugan_eyeball_normal.png");
    colorMap.colorSpace = THREE.SRGBColorSpace;

    // 3. Realistic Anatomical Sclera & Iris Mesh
    const sphereGeo = new THREE.SphereGeometry(1.2, 64, 64);
    // Rotate texture so the iris points directly forward (+Z)
    sphereGeo.rotateY(-Math.PI / 2);

    const eyeballMat = new THREE.MeshPhysicalMaterial({
      map: colorMap,
      normalMap: normalMap,
      normalScale: new THREE.Vector2(0.85, 0.85),
      roughness: 0.15,
      metalness: 0.05,
      clearcoat: 1.0,
      clearcoatRoughness: 0.08,
      reflectivity: 0.95,
      emissive: new THREE.Color(0x312e81),
      emissiveIntensity: 0.22,
    });
    const eyeball = new THREE.Mesh(sphereGeo, eyeballMat);
    eyeOrbitGroup.add(eyeball);

    // 4. Glossy Cornea / Tear Film Outer Bulge
    const corneaGeo = new THREE.SphereGeometry(1.23, 64, 64);
    const corneaMat = new THREE.MeshPhysicalMaterial({
      color: 0xffffff,
      transmission: 0.95,
      opacity: 1,
      transparent: true,
      roughness: 0.02,
      ior: 1.376, // Genuine corneal refractive index
      clearcoat: 1.0,
      clearcoatRoughness: 0.02,
    });
    const cornea = new THREE.Mesh(corneaGeo, corneaMat);
    eyeOrbitGroup.add(cornea);

    // 5. Anime Byakugan Jutsu Chakra Veins (3D Procedural Vein Network)
    const veinSystem = new THREE.Group();
    const veinCount = 14;
    for (let i = 0; i < veinCount; i++) {
      const theta = (i / veinCount) * Math.PI * 2 + (Math.random() - 0.5) * 0.2;
      const points: THREE.Vector3[] = [];
      const steps = 7;
      let currR = 1.22;
      let currAngle = theta;
      let zOffset = 0.2 - Math.random() * 0.4;

      for (let j = 0; j <= steps; j++) {
        currR += 0.22 + Math.random() * 0.1;
        currAngle += (Math.random() - 0.5) * 0.18;
        points.push(
          new THREE.Vector3(
            Math.cos(currAngle) * currR,
            Math.sin(currAngle) * currR,
            zOffset - j * 0.08
          )
        );
      }
      const curve = new THREE.CatmullRomCurve3(points);
      const veinGeo = new THREE.TubeGeometry(curve, 24, 0.022 - (i % 3) * 0.005, 8, false);
      const veinMat = new THREE.MeshBasicMaterial({
        color: i % 2 === 0 ? 0x60a5fa : 0xa78bfa,
        transparent: true,
        opacity: 0.75,
      });
      const veinMesh = new THREE.Mesh(veinGeo, veinMat);
      veinSystem.add(veinMesh);
    }
    eyeSystem.add(veinSystem);

    // 6. Holographic Optical Reticle Rings (Anime HUD Targeting)
    const rings: THREE.Mesh[] = [];
    const ringConfigs = [
      { r: 1.6, color: 0x818cf8, rotX: 0.15, rotY: 0.1, speed: 0.006 },
      { r: 2.1, color: 0x38bdf8, rotX: -0.25, rotY: 0.2, speed: -0.005 },
      { r: 2.65, color: 0xc084fc, rotX: 0.2, rotY: -0.15, speed: 0.004 },
    ];

    ringConfigs.forEach((cfg) => {
      const geo = new THREE.TorusGeometry(cfg.r, 0.014, 16, 96);
      const mat = new THREE.MeshBasicMaterial({
        color: cfg.color,
        transparent: true,
        opacity: 0.7,
      });
      const ring = new THREE.Mesh(geo, mat);
      ring.rotation.x = cfg.rotX;
      ring.rotation.y = cfg.rotY;
      eyeSystem.add(ring);
      rings.push(ring);
    });

    // Outer Target Ticks
    const tickGroup = new THREE.Group();
    for (let i = 0; i < 36; i++) {
      const angle = (i / 36) * Math.PI * 2;
      const isMajor = i % 4 === 0;
      const r1 = 2.45;
      const r2 = isMajor ? 2.65 : 2.55;
      const tickGeo = new THREE.BufferGeometry().setFromPoints([
        new THREE.Vector3(Math.cos(angle) * r1, Math.sin(angle) * r1, 0),
        new THREE.Vector3(Math.cos(angle) * r2, Math.sin(angle) * r2, 0),
      ]);
      const tickLine = new THREE.Line(
        tickGeo,
        new THREE.LineBasicMaterial({
          color: isMajor ? 0x38bdf8 : 0x818cf8,
          transparent: true,
          opacity: isMajor ? 0.9 : 0.45,
        })
      );
      tickGroup.add(tickLine);
    }
    eyeSystem.add(tickGroup);

    // 7. Swirling Chakra Particle Aura
    const particleCount = 280;
    const particleGeo = new THREE.BufferGeometry();
    const particlePositions = new Float32Array(particleCount * 3);

    for (let i = 0; i < particleCount * 3; i += 3) {
      const theta = Math.random() * Math.PI * 2;
      const phi = Math.acos(Math.random() * 2 - 1);
      const r = 1.9 + Math.random() * 2.8;
      particlePositions[i] = r * Math.sin(phi) * Math.cos(theta);
      particlePositions[i + 1] = r * Math.sin(phi) * Math.sin(theta);
      particlePositions[i + 2] = r * Math.cos(phi);
    }
    particleGeo.setAttribute("position", new THREE.BufferAttribute(particlePositions, 3));

    const particleMat = new THREE.PointsMaterial({
      color: 0xc4b5fd,
      size: 0.05,
      transparent: true,
      opacity: 0.75,
      blending: THREE.AdditiveBlending,
    });
    const particles = new THREE.Points(particleGeo, particleMat);
    eyeSystem.add(particles);

    // 8. Dynamic Lighting
    const ambientLight = new THREE.AmbientLight(0xffffff, 1.2);
    scene.add(ambientLight);

    const mainKeyLight = new THREE.DirectionalLight(0xffffff, 2.5);
    mainKeyLight.position.set(4, 5, 6);
    scene.add(mainKeyLight);

    const purpleFillLight = new THREE.PointLight(0xa855f7, 3.5, 15);
    purpleFillLight.position.set(-4, -2, 3);
    scene.add(purpleFillLight);

    const cyanRimLight = new THREE.PointLight(0x38bdf8, 3.0, 12);
    cyanRimLight.position.set(0, -4, -2);
    scene.add(cyanRimLight);

    // 9. Interactive Mouse Gaze + Scroll Trajectory
    let mouseX = 0;
    let mouseY = 0;
    let targetEyeRotX = 0;
    let targetEyeRotY = 0;
    let scrollProgress = 0;

    let targetX = 2.2;
    let targetY = 0;
    let targetZ = 0;
    let targetScale = 1;

    const handleScroll = () => {
      const maxScroll = document.documentElement.scrollHeight - window.innerHeight;
      scrollProgress = maxScroll > 0 ? window.scrollY / maxScroll : 0;
      const isMobile = window.innerWidth < 768;

      if (isMobile) {
        targetX = 0;
        targetY = 0.6 - scrollProgress * 0.9;
        targetZ = -1.5;
        targetScale = 0.68;
      } else {
        if (scrollProgress < 0.22) {
          // Section 1: Hero Right
          const p = scrollProgress / 0.22;
          targetX = THREE.MathUtils.lerp(2.2, 1.8, p);
          targetY = THREE.MathUtils.lerp(0, -0.4, p);
          targetZ = 0;
          targetScale = THREE.MathUtils.lerp(1, 0.9, p);
        } else if (scrollProgress < 0.48) {
          // Section 2: Manga Lore Left
          const p = (scrollProgress - 0.22) / 0.26;
          targetX = THREE.MathUtils.lerp(1.8, -2.6, p);
          targetY = THREE.MathUtils.lerp(-0.4, 0.2, p);
          targetZ = THREE.MathUtils.lerp(0, 0.5, p);
          targetScale = THREE.MathUtils.lerp(0.9, 1.15, p);
        } else if (scrollProgress < 0.72) {
          // Section 3: Behind Interactive HUD
          const p = (scrollProgress - 0.48) / 0.24;
          targetX = THREE.MathUtils.lerp(-2.6, 2.5, p);
          targetY = THREE.MathUtils.lerp(0.2, -0.1, p);
          targetZ = THREE.MathUtils.lerp(0.5, -0.5, p);
          targetScale = THREE.MathUtils.lerp(1.15, 0.85, p);
        } else {
          // Section 4: Finale Center Top
          const p = (scrollProgress - 0.72) / 0.28;
          targetX = THREE.MathUtils.lerp(2.5, 0, p);
          targetY = THREE.MathUtils.lerp(-0.1, 1.2, p);
          targetZ = THREE.MathUtils.lerp(-0.5, -0.2, p);
          targetScale = THREE.MathUtils.lerp(0.85, 1.25, p);
        }
      }
    };

    const handleMouseMove = (e: MouseEvent) => {
      mouseX = (e.clientX / window.innerWidth) * 2 - 1;
      mouseY = -(e.clientY / window.innerHeight) * 2 + 1;
      // Eyeball tracks the cursor directly
      targetEyeRotY = mouseX * 0.55;
      targetEyeRotX = -mouseY * 0.45;
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
    handleScroll();

    // 10. Animation Loop
    let animId: number;
    const clock = new THREE.Clock();

    const animate = () => {
      animId = requestAnimationFrame(animate);
      const time = clock.getElapsedTime();

      // Smooth position interpolation
      eyeSystem.position.x += (targetX - eyeSystem.position.x) * 0.05;
      eyeSystem.position.y += (targetY - eyeSystem.position.y) * 0.05;
      eyeSystem.position.z += (targetZ - eyeSystem.position.z) * 0.05;

      const currScale = eyeSystem.scale.x;
      const nextScale = currScale + (targetScale - currScale) * 0.05;
      eyeSystem.scale.set(nextScale, nextScale, nextScale);

      // Saccadic natural eye gaze tracking towards user cursor
      eyeOrbitGroup.rotation.y += (targetEyeRotY - eyeOrbitGroup.rotation.y) * 0.08;
      eyeOrbitGroup.rotation.x += (targetEyeRotX - eyeOrbitGroup.rotation.x) * 0.08;

      // Optical rings counter-spin
      rings.forEach((ring, idx) => {
        const dir = idx % 2 === 0 ? 1 : -1;
        ring.rotation.z += 0.005 * dir;
      });

      tickGroup.rotation.z -= 0.002;
      particles.rotation.y += 0.0012;
      veinSystem.rotation.z += 0.0015;

      // Pulse chakra
      const pulse = 1 + Math.sin(time * 3) * 0.02;
      eyeball.scale.set(pulse, pulse, pulse);
      cornea.scale.set(pulse, pulse, pulse);

      renderer.render(scene, camera);
    };

    animate();

    return () => {
      cancelAnimationFrame(animId);
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
