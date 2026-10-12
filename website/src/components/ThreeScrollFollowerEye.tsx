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
    eyeSystem.position.set(2.4, 0.0, 0);

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
      roughness: 0.18,
      metalness: 0.05,
      clearcoat: 1.0,
      clearcoatRoughness: 0.08,
      reflectivity: 0.95,
      emissive: new THREE.Color(0x4a0420),
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

    // 5. Anime Byakugan Jutsu Chakra Veins (Multi-Color Anime Palette)
    const veinSystem = new THREE.Group();
    const veinColors = [0xf43f5e, 0xd946ef, 0x06b6d4, 0xfbbf24];
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
        color: veinColors[i % veinColors.length],
        transparent: true,
        opacity: 0.55,
      });
      const veinMesh = new THREE.Mesh(veinGeo, veinMat);
      veinSystem.add(veinMesh);
    }
    eyeSystem.add(veinSystem);

    // 6. Holographic Optical Reticle Rings (Soothing Luminescent HUD)
    const rings: THREE.Mesh[] = [];
    const ringConfigs = [
      { r: 1.6, color: 0xf43f5e, rotX: 0.15, rotY: 0.1, speed: 0.006 },
      { r: 2.1, color: 0xd946ef, rotX: -0.25, rotY: 0.2, speed: -0.005 },
      { r: 2.65, color: 0x06b6d4, rotX: 0.2, rotY: -0.15, speed: 0.004 },
    ];

    ringConfigs.forEach((cfg) => {
      const geo = new THREE.TorusGeometry(cfg.r, 0.012, 16, 96);
      const mat = new THREE.MeshBasicMaterial({
        color: cfg.color,
        transparent: true,
        opacity: 0.45,
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
          color: isMajor ? 0xf43f5e : 0xfb7185,
          transparent: true,
          opacity: isMajor ? 0.9 : 0.45,
        })
      );
      tickGroup.add(tickLine);
    }
    eyeSystem.add(tickGroup);

    // 7. Swirling Chakra Particle Aura (Pink/Rose Luminescence)
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
      color: 0xf472b6,
      size: 0.035,
      transparent: true,
      opacity: 0.45,
      blending: THREE.AdditiveBlending,
    });
    const particles = new THREE.Points(particleGeo, particleMat);
    eyeSystem.add(particles);

    // 8. Dynamic Lighting (Magenta & Cyberpunk Accents)
    const ambientLight = new THREE.AmbientLight(0xffffff, 1.2);
    scene.add(ambientLight);

    const mainKeyLight = new THREE.DirectionalLight(0xffffff, 2.4);
    mainKeyLight.position.set(4, 5, 6);
    scene.add(mainKeyLight);

    const magentaFillLight = new THREE.PointLight(0xf43f5e, 4.0, 16);
    magentaFillLight.position.set(-4, -2, 3);
    scene.add(magentaFillLight);

    const cyanRimLight = new THREE.PointLight(0x06b6d4, 2.8, 12);
    cyanRimLight.position.set(0, -4, -2);
    scene.add(cyanRimLight);

    const topFuchsiaLight = new THREE.PointLight(0xd946ef, 3.0, 14);
    topFuchsiaLight.position.set(2, 4, 2);
    scene.add(topFuchsiaLight);

    // 9. Seamless Waypoint Choreography & Dynamic Mouse Tracking
    let mouseX = 0;
    let mouseY = 0;
    let targetEyeRotX = 0;
    let targetEyeRotY = 0;
    let currentScrollProgress = 0;

    // Semantic trajectory keyframes mapped to the updated clean page structure:
    // 1. Hero: Rests naturally in the open right stage beside the typography
    // 2. Manga Lore / Philosophy: Glides smoothly to the left stage
    // 3. Capabilities: Recedes with depth onto the right perimeter
    // 4. Specs: Hovers at upper-left depth
    // 5. Finale CTA: Smoothly descends into the top center above "ACTIVATE YOUR VISION"
    const WAYPOINTS_DESKTOP = [
      { t: 0.00, x: 2.4,  y: 0.00, z: 0.0,  scale: 1.08 },
      { t: 0.30, x: -2.2, y: 0.00, z: 0.1,  scale: 1.05 },
      { t: 0.65, x: 2.2,  y: 0.25, z: -1.2, scale: 0.82 },
      { t: 0.85, x: -2.0, y: 0.15, z: -1.0, scale: 0.85 },
      { t: 1.00, x: 0.0,  y: 0.95, z: -0.3, scale: 1.15 },
    ];

    const getTrajectoryAt = (p: number, isMobile: boolean) => {
      const clampedP = Math.max(0, Math.min(1, p));

      if (isMobile) {
        return {
          x: 0,
          y: THREE.MathUtils.lerp(0.85, -0.2, clampedP),
          z: -2.0,
          scale: 0.60,
        };
      }

      for (let i = 0; i < WAYPOINTS_DESKTOP.length - 1; i++) {
        const w0 = WAYPOINTS_DESKTOP[i];
        const w1 = WAYPOINTS_DESKTOP[i + 1];

        if (clampedP >= w0.t && clampedP <= w1.t) {
          const span = w1.t - w0.t;
          const localT = span > 0 ? (clampedP - w0.t) / span : 0;
          // Smooth cosine easing for continuous, zero-jerk velocity transition
          const ease = 0.5 * (1 - Math.cos(localT * Math.PI));

          return {
            x: THREE.MathUtils.lerp(w0.x, w1.x, ease),
            y: THREE.MathUtils.lerp(w0.y, w1.y, ease),
            z: THREE.MathUtils.lerp(w0.z, w1.z, ease),
            scale: THREE.MathUtils.lerp(w0.scale, w1.scale, ease),
          };
        }
      }

      const last = WAYPOINTS_DESKTOP[WAYPOINTS_DESKTOP.length - 1];
      return { x: last.x, y: last.y, z: last.z, scale: last.scale };
    };

    let targetX = 2.4;
    let targetY = 0.00;
    let targetZ = 0.0;
    let targetScale = 1.08;

    const handleScroll = () => {
      const maxScroll = document.documentElement.scrollHeight - window.innerHeight;
      currentScrollProgress = maxScroll > 0 ? window.scrollY / maxScroll : 0;
      const isMobile = window.innerWidth < 768;
      const traj = getTrajectoryAt(currentScrollProgress, isMobile);
      targetX = traj.x;
      targetY = traj.y;
      targetZ = traj.z;
      targetScale = traj.scale;
    };

    const handleMouseMove = (e: MouseEvent) => {
      mouseX = (e.clientX / window.innerWidth) * 2 - 1;
      mouseY = -(e.clientY / window.innerHeight) * 2 + 1;
      // Eyeball tracks the cursor smoothly
      targetEyeRotY = mouseX * 0.45;
      targetEyeRotX = -mouseY * 0.35;
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

      // Smooth position & scale lerping (6.5% per frame provides buttery organic physics)
      eyeSystem.position.x = THREE.MathUtils.lerp(eyeSystem.position.x, targetX, 0.065);
      eyeSystem.position.y = THREE.MathUtils.lerp(eyeSystem.position.y, targetY, 0.065);
      eyeSystem.position.z = THREE.MathUtils.lerp(eyeSystem.position.z, targetZ, 0.065);

      const currScale = eyeSystem.scale.x;
      const nextScale = THREE.MathUtils.lerp(currScale, targetScale, 0.065);
      eyeSystem.scale.set(nextScale, nextScale, nextScale);

      // Natural eye gaze: cursor tracking combined with subtle organic saccades
      const saccadeX = Math.sin(time * 0.9) * 0.015;
      const saccadeY = Math.cos(time * 0.7) * 0.012;
      const finalRotY = targetEyeRotY + saccadeX;
      const finalRotX = targetEyeRotX + saccadeY;

      eyeOrbitGroup.rotation.y = THREE.MathUtils.lerp(eyeOrbitGroup.rotation.y, finalRotY, 0.07);
      eyeOrbitGroup.rotation.x = THREE.MathUtils.lerp(eyeOrbitGroup.rotation.x, finalRotX, 0.07);

      // Optical rings counter-spin
      rings.forEach((ring, idx) => {
        const dir = idx % 2 === 0 ? 1 : -1;
        ring.rotation.z += 0.005 * dir;
      });

      tickGroup.rotation.z -= 0.002;
      particles.rotation.y += 0.0012;
      veinSystem.rotation.z += 0.0015;

      // Pulse chakra gently
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
