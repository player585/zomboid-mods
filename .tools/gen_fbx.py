#!/usr/bin/env python3
"""Generate a minimal ASCII FBX placeholder model for the Electric Scooter.

The mesh is a low-poly approximation: deck (long flat box), two wheels
(short fat boxes — yes, square wheels; this is a placeholder), and a
handlebar post + bar. ~24 vertices total.

ASCII FBX format reference (informal): each top-level block is a named
Object with curly braces, integers as their own type, doubles as their own
type, and vertex/poly data inline as comma-separated lists.

Project Zomboid's vehicle loader accepts ASCII FBX 7.x. Real artists will
replace this with a proper .fbx exported from Blender or Sketchfab.
"""

from __future__ import annotations
import os, datetime, struct

OUT_PATH = os.path.join(
    os.path.dirname(__file__), "..",
    "mods", "electric-scooter", "Contents", "mods", "ElectricScooter",
    "common", "media", "models", "vehicles", "ElectricScooter.fbx",
)
os.makedirs(os.path.dirname(OUT_PATH), exist_ok=True)


def box(cx, cy, cz, sx, sy, sz):
    """Return (vertices, faces) for an axis-aligned box centered at (cx,cy,cz)."""
    hx, hy, hz = sx / 2, sy / 2, sz / 2
    v = [
        (cx - hx, cy - hy, cz - hz),
        (cx + hx, cy - hy, cz - hz),
        (cx + hx, cy + hy, cz - hz),
        (cx - hx, cy + hy, cz - hz),
        (cx - hx, cy - hy, cz + hz),
        (cx + hx, cy - hy, cz + hz),
        (cx + hx, cy + hy, cz + hz),
        (cx - hx, cy + hy, cz + hz),
    ]
    # 6 faces, each as a quad of vertex indices (0-based, local to this box)
    f = [
        (0, 1, 2, 3),   # bottom
        (4, 5, 6, 7),   # top
        (0, 1, 5, 4),   # front
        (2, 3, 7, 6),   # back
        (1, 2, 6, 5),   # right
        (0, 3, 7, 4),   # left
    ]
    return v, f


def main() -> None:
    # ---- Build mesh ----------------------------------------------------
    # Coords: X=right, Y=up, Z=forward. Scale ~real scooter in meters.
    parts = []
    parts.append(box(cx=0.00, cy=0.10, cz=0.00,  sx=0.20, sy=0.05, sz=0.80))  # deck
    parts.append(box(cx=0.00, cy=0.10, cz=+0.45, sx=0.18, sy=0.18, sz=0.06))  # front wheel
    parts.append(box(cx=0.00, cy=0.10, cz=-0.45, sx=0.18, sy=0.18, sz=0.06))  # rear wheel
    parts.append(box(cx=0.00, cy=0.55, cz=+0.40, sx=0.05, sy=0.85, sz=0.05))  # handlebar post
    parts.append(box(cx=0.00, cy=0.95, cz=+0.40, sx=0.50, sy=0.04, sz=0.04))  # handlebar

    verts = []
    faces = []  # list of (i0,i1,i2,i3)
    for v_local, f_local in parts:
        offset = len(verts)
        verts.extend(v_local)
        for quad in f_local:
            faces.append(tuple(i + offset for i in quad))

    # ---- FBX requires triangles for some loaders; emit quads as two tris
    # by negating the last index per FBX convention (n-gon end marker).
    poly_indices = []
    for q in faces:
        a, b, c, d = q
        # FBX 7 convention: last vertex of a polygon is bitwise-NOT (= -1-x)
        poly_indices.extend([a, b, c, -1 - d])

    # ---- Emit ASCII FBX -----------------------------------------------
    today = datetime.datetime.now()
    creation_time = today.strftime("%Y-%m-%d %H:%M:%S:000")

    verts_flat = ",".join(f"{x:.6f},{y:.6f},{z:.6f}" for x, y, z in verts)
    poly_flat  = ",".join(str(i) for i in poly_indices)

    fbx = f"""; FBX 7.4.0 project file (ASCII)
; Generated for zomboid-mods/electric-scooter placeholder mesh
; ----------------------------------------------------------------------

FBXHeaderExtension:  {{
\tFBXHeaderVersion: 1003
\tFBXVersion: 7400
\tCreationTimeStamp:  {{
\t\tVersion: 1000
\t\tYear: {today.year}
\t\tMonth: {today.month}
\t\tDay: {today.day}
\t\tHour: {today.hour}
\t\tMinute: {today.minute}
\t\tSecond: {today.second}
\t\tMillisecond: 0
\t}}
\tCreator: "zmodder placeholder fbx writer"
}}

CreationTime: "{creation_time}"
Creator: "zmodder placeholder fbx writer"

GlobalSettings:  {{
\tVersion: 1000
\tProperties70:  {{
\t\tP: "UpAxis", "int", "Integer", "",1
\t\tP: "UpAxisSign", "int", "Integer", "",1
\t\tP: "FrontAxis", "int", "Integer", "",2
\t\tP: "FrontAxisSign", "int", "Integer", "",1
\t\tP: "CoordAxis", "int", "Integer", "",0
\t\tP: "CoordAxisSign", "int", "Integer", "",1
\t\tP: "UnitScaleFactor", "double", "Number", "",1
\t}}
}}

Objects:  {{
\tGeometry: 1000001, "Geometry::ElectricScooter", "Mesh" {{
\t\tVertices: *{len(verts)*3} {{
\t\t\ta: {verts_flat}
\t\t}}
\t\tPolygonVertexIndex: *{len(poly_indices)} {{
\t\t\ta: {poly_flat}
\t\t}}
\t\tGeometryVersion: 124
\t\tLayerElementNormal: 0 {{
\t\t\tVersion: 101
\t\t\tName: ""
\t\t\tMappingInformationType: "ByPolygonVertex"
\t\t\tReferenceInformationType: "Direct"
\t\t}}
\t\tLayer: 0 {{
\t\t\tVersion: 100
\t\t\tLayerElement:  {{
\t\t\t\tType: "LayerElementNormal"
\t\t\t\tTypedIndex: 0
\t\t\t}}
\t\t}}
\t}}

\tModel: 2000001, "Model::ElectricScooter", "Mesh" {{
\t\tVersion: 232
\t\tProperties70:  {{
\t\t\tP: "Lcl Translation", "Lcl Translation", "", "A",0,0,0
\t\t\tP: "Lcl Rotation", "Lcl Rotation", "", "A",0,0,0
\t\t\tP: "Lcl Scaling", "Lcl Scaling", "", "A",1,1,1
\t\t}}
\t\tShading: T
\t\tCulling: "CullingOff"
\t}}
}}

Connections:  {{
\tC: "OO",1000001,2000001
\tC: "OO",2000001,0
}}
"""

    with open(OUT_PATH, "w") as f:
        f.write(fbx)
    size = os.path.getsize(OUT_PATH)
    print(f"  wrote {os.path.relpath(OUT_PATH)}")
    print(f"    {len(verts)} vertices, {len(faces)} quads, {size:,} bytes")


if __name__ == "__main__":
    main()
