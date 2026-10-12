"use client";

import { useEffect, useRef } from "react";
import * as THREE from "three";

export default function ThreeHeroEye() {
  const mountRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const container = mountRef.current;
    if (!container) return;

    // 1. Scene, Camera, Renderer
    const scene = new THREE.Scene();
    const width = container.clientWidth;
    const height = container.clientHeight;
    const camera = new THREE.PerspectiveCamera(45, width / height, 0.1, 100);
    camera.position.z = 7;

    const renderer = new THREE.WebGLRenderer({ alpha: true, antialias: true });
    renderer.setSize(width, height);
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
    container.appendChild(renderer.domElement);

    // Group holding the entire Byakugan eye reticle
    const eyeGroup = new THREE.Group();
    scene.add(eyeGroup);

    // 2. Center Byakugan Iris (Ethereal glowing pearlescent lavender core)
    const irisGeometry = new THREE.SphereGeometry(1.2, 48, 48);
    const irisMaterial = new THREE.MeshStandardMaterial({
      color: 0xede9fe, // pale lavender/white
      roughness: 0.2,
      metalness: 0.1,
      emissive: 0xc4b5fd,
      emissiveIntensity: 0.35,
    });
    const iris = new THREE.Mesh(irisGeometry, irisMaterial);
    eyeGroup.add(iris);

    // Pupil-less inner concentric ring (Signature Byakugan iris detail)
    const innerRingGeo = new THREE.TorusGeometry(0.7, 0.02, 16, 64);
    const ringMat = new THREE.MeshBasicMaterial({ color: 0x818cf8, wireframe: false });
    const innerRing = new THREE.Mesh(innerRingGeo, ringMat);
    eyeGroup.add(innerRing);

    // 3. Concentric Scanning Reticle Rings (Concentric holographic rings)
    const rings: THREE.Mesh[] = [];
    const ringRadii = [1.6, 2.1, 2.6, 3.1];

    ringRadii.forEach((radius, idx) => {
      const geo = new THREE.TorusGeometry(radius, 0.015, 16, 80);
      const mat = new THREE.MeshBasicMaterial({
        color: idx % 2 === 0 ? 0x6366f1 : 0x38bdf8,
        transparent: true,
        opacity: 0.5 - idx * 0.08,
      });
      const mesh = new THREE.Mesh(geo, mat);
      // Give slightly different inclinations
      mesh.rotation.x = (idx * 0.15);
      mesh.rotation.y = (idx * 0.2);
      eyeGroup.add(mesh);
      rings.push(mesh);
    });

    // 4. Crosshair coordinate ticks around the scanner
    const tickGroup = new THREE.Group();
    for (let i = 0; i < 24; i++) {
      const angle = (i / 24) * Math.PI * 2;
      const tickGeo = new THREE.BufferGeometry().setFromPoints([
        new THREE.Vector3(Math.cos(angle) * 2.5, Math.sin(angle) * 2.5, 0),
        new THREE.Vector3(Math.cos(angle) * 2.7, Math.sin(angle) * 2.7, 0),
      ]);
      const tickLine = new THREE.Line(
        tickGeo,
        new THREE.LineBasicMaterial({ color: 0x818cf8, transparent: true, opacity: 0.6 })
      );
      tickGroup.add(tickLine);
    }
    eyeGroup.add(tickGroup);

    // 5. Surrounding Chakra Particle Swarm
    const particleCount = 200;
    const particleGeometry = new THREE.BufferGeometry();
    const positions = new Float32Array(particleCount * 3);

    for (let i = 0; i < particleCount * 3; i += 3) {
      const theta = Math.random() * Math.PI * 2;
      const phi = Math.acos(Math.random() * 2 - 1);
      const r = 2.0 + Math.random() * 2.2;
      positions[i] = r * Math.sin(phi) * Math.cos(theta);
      positions[i + 1] = r * Math.sin(phi) * Math.sin(theta);
      positions[i + 2] = r * Math.cos(phi);
    }
    particleGeometry.setAttribute("position", new THREE.BufferAttribute(positions, 3));

    const particleMaterial = new THREE.PointsMaterial({
      color: 0xa5b4fc,
      size: 0.045,
      transparent: true,
      opacity: 0.7,
      blending: THREE.AdditiveBlending,
    });
    const particles = new THREE.Points(particleGeometry, particleMaterial);
    eyeGroup.add(particles);

    // 6. Lighting
    const ambientLight = new THREE.AmbientLight(0xffffff, 0.8);
    scene.add(ambientLight);

    const pointLight = new THREE.PointLight(0xa78bfa, 2.5, 12);
    pointLight.position.set(2, 3, 4);
    scene.add(pointLight);

    const blueBacklight = new THREE.PointLight(0x38bdf8, 2, 10);
    blueBacklight.position.set(-3, -2, -2);
    scene.add(blueBacklight);

    // 7. Interactive Mouse / Scroll Tracking
    let targetRotationX = 0;
    let targetRotationY = 0;
    let mouseX = 0;
    let mouseY = 0;

    const handleMouseMove = (e: MouseEvent) => {
      const rect = container.getBoundingClientRect();
      const x = ((e.clientX - rect.left) / rect.width) * 2 - 1;
      const y = -(((e.clientY - rect.top) / rect.height) * 2 - 1);
      mouseX = x;
      mouseY = y;
      targetRotationY = x * 0.45;
      targetRotationX = -y * 0.35;
    };

    window.addEventListener("mousemove", handleMouseMove);

    // Resize handling
    const handleResize = () => {
      if (!container) return;
      const w = container.clientWidth;
      const h = container.clientHeight;
      camera.aspect = w / h;
      camera.updateProjectionMatrix();
      renderer.setSize(w, h);
    };
    window.addEventListener("resize", handleResize);

    // 8. Animation Loop
    let animationFrameId: number;
    let clock = new THREE.Clock();

    const animate = () => {
      animationFrameId = requestAnimationFrame(animate);
      const elapsedTime = clock.getElapsedTime();

      // Smooth camera/eye orientation towards cursor (Byakugan tracking)
      eyeGroup.rotation.y += (targetRotationY - eyeGroup.rotation.y) * 0.05;
      eyeGroup.rotation.x += (targetRotationX - eyeGroup.rotation.x) * 0.05;

      // Reticle rings counter-rotation
      rings.forEach((ring, idx) => {
        const direction = idx % 2 === 0 ? 1 : -1;
        ring.rotation.z += 0.004 * direction;
      });

      tickGroup.rotation.z -= 0.002;
      particles.rotation.y += 0.0015;

      // Gentle pulsating breathing
      const pulse = 1 + Math.sin(elapsedTime * 2) * 0.02;
      iris.scale.set(pulse, pulse, pulse);

      renderer.render(scene, camera);
    };

    animate();

    return () => {
      cancelAnimationFrame(animationFrameId);
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
      ref={mountRef}
      className="w-full h-full min-h-[380px] sm:min-h-[460px] cursor-grab active:cursor-grabbing relative"
      aria-label="Interactive 3D Byakugan Scanner Eye"
    />
  );
}
