using System;
using System.Collections;
using System.Collections.Generic;
using System.Security.Cryptography;
using UnityEngine;

public class TetrisBlock : MonoBehaviour
{
    public static int period = 6;
    private static int roundCounter = 0;
    private static int generation = 0;
    
    public Vector3 rotationPoint;
    private float previousTime;
    public float fallTime = 0.8f;

    public int fadingTurn;
    
    public static int height = 20;
    public static int width = 10;
    public static Transform[,] grid = new Transform[width,height];

    // Start is called before the first frame update
    void Start()
    {
        fadingTurn = transform.childCount;
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.LeftArrow))
        {
            transform.position += new Vector3(-1, 0, 0);
            if (!ValidMove())
            {
                transform.position -= new Vector3(-1, 0, 0);
            }
        }else if (Input.GetKeyDown(KeyCode.RightArrow))
        {
            transform.position += new Vector3(1, 0, 0);
            if (!ValidMove())
            {
                transform.position -= new Vector3(1, 0, 0);
            }
        }else if (Input.GetKeyDown(KeyCode.C))
        {
            transform.RotateAround( transform.TransformPoint(rotationPoint), new Vector3(0,0,1), 90 );
            if (!ValidMove())
            {
                transform.RotateAround( transform.TransformPoint(rotationPoint), new Vector3(0,0,1), -90 );
            }
        }

        if (Time.time - previousTime >= (Input.GetKey(KeyCode.DownArrow) ? fallTime /10 : fallTime ) )
        {
            transform.position += new Vector3(0, -1, 0);
            if (!ValidMove())
            {
                FindObjectOfType<SpawnBlock>().audioManager.PlaySound("blocked");

                
                transform.position -= new Vector3(0, -1, 0);
                AddToGrid();
                CheckForLines();
                // collect drops
                
                // apply conway
                TetrisBlock.ApplyConway();
                
                // 
                this.enabled = false;
                FindObjectOfType<SpawnBlock>().NewBlock();
                
                //
                // CheckGameOver();
            }
            previousTime = Time.time;
        }
    }

    void CheckForLines()
    {
        for (int i = height - 1; i >= 0; i--)
        {
            if (HasLine(i))
            {
                DeleteLine(i);
                
                FindObjectOfType<SpawnBlock>().audioManager.PlaySound("clear_line");
                RowDown(i);
            }
        }
    }

    bool HasLine(int row)
    {
        for (int j = 0; j < width; j++)
        {
            if (grid[j, row] == null)
            {
                return false;
            }
        }
        return true;
    }

    void DeleteLine(int row)
    {
        for (int j = 0; j < width; j++)
        {
            TileItemDrops comp = grid[j, row].gameObject.GetComponent<TileItemDrops>();
            if ( comp != null)
            {
                Vector3 newRotation = Quaternion.Euler(new Vector3(0, 0, comp.transform.rotation.eulerAngles.z)) *
                                      new Vector3(comp.blockLocation.x, comp.blockLocation.y, 0);
                
                // Debug.Log("x,y,rot " + comp.blockLocation.x+" "+comp.blockLocation.y + " " + comp.transform.rotation.eulerAngles.z);
                // Debug.Log("new x,y " + newRotation.x + " " + newRotation.y);
                
                FindObjectOfType<WeaponsPanel>().SetAt( Mathf.RoundToInt(newRotation.x), Mathf.RoundToInt(newRotation.y));
            }
            Destroy( grid[j, row].gameObject);
            grid[j, row] = null;
        }
    }

    void RowDown(int row)
    {
        for (int y = row; y < height; y++)
        {
            for (int j = 0; j < width; j++)
            {
                if (grid[j, y] != null)
                {
                    grid[j, y - 1] = grid[j, y];
                    grid[j, y] = null;
                    grid[j, y-1].transform.position -= new Vector3(0, 1, 0);
                }

            }
        }


    }
    
    void AddToGrid()
    {
        foreach (Transform child in transform)
        {
            int roundedX = Mathf.RoundToInt(child.transform.position.x);
            int roundedY = Mathf.RoundToInt(child.transform.position.y);

            grid[roundedX, roundedY] = child;
        }
    }

    bool ValidMove()
    {
        foreach (Transform child in transform)
        {
            int roundedX = Mathf.RoundToInt(child.transform.position.x);
            int roundedY = Mathf.RoundToInt(child.transform.position.y);

            if (roundedX < 0 || roundedX >= width || roundedY < 0 || roundedY >= height)
            {
                return false;
            }

            if (grid[roundedX, roundedY] != null )
            {
                return false;
            }
        }

        return true;
    }


    static public void ApplyConway()
    {
        if (roundCounter >= period)
        {
            generation++;
            FindObjectOfType<SpawnBlock>().generationCount.text = generation.ToString();

            
            roundCounter = 0;
            
            // generate bool map from grid
            bool [,] currentGrid = new bool[width,height];

            for (int i = 0; i < width; i++)
            {
                for (int j = 0; j < height; j++)
                {
                    currentGrid[i, j] = grid[i, j] != null;
                }
            }
            
            bool [,] nextStepGrid = new bool[width,height];
            for (int i = 0; i < width; i++)
            {
                for (int j = 0; j < height; j++)
                {
                    int c = CountNeighbours(currentGrid, i, j);
                    if ( currentGrid[i,j] && c < 2)
                    {
                        // Debug.Log("Isolation "+ "c=" + c + ", i,j=" + i + "," + j);
                        nextStepGrid[i, j] = false;
                    
                        Destroy( grid[i,j].gameObject, 0f );
                        grid[i, j] = null;
                    
                    }else if ( currentGrid[i,j] && (c == 2 || c == 3))
                    {
                        // Debug.Log("Unchanged  "+ "c=" + c + ", i,j=" + i + "," + j);
                        nextStepGrid[i, j] = true;

                        if (grid[i, j] != null)
                        {
                            Destroy( grid[i,j].gameObject, 0f );
                            grid[i, j] = null;
                        }
                    
                        GameObject go = Instantiate( FindObjectOfType<SpawnBlock>().PlaceHolder, new Vector3(i, j, 0), Quaternion.identity);
                        grid[i, j] = go.transform;
                    }else if ( currentGrid[i,j] && c > 3)
                    {
                        // Debug.Log("Overcrowded "+ "c=" + c + ", i,j=" + i + "," + j);
                        nextStepGrid[i, j] = false;
                    
                        Destroy( grid[i,j].gameObject, 0f );
                        grid[i, j] = null;
                    
                    }else if ( !currentGrid[i,j] && c == 3 )
                    {
                        // Debug.Log("ALIVE"+ "c=" + c + ", i,j=" + i + "," + j);
                        nextStepGrid[i, j] = true;
                    
                        GameObject go = Instantiate( FindObjectOfType<SpawnBlock>().PlaceHolder, new Vector3(i, j, 0), Quaternion.identity);
                        grid[i, j] = go.transform;
                    }
                }
            }
            
            
            
        }
        else
        {
            roundCounter++;
        }

        FindObjectOfType<SpawnBlock>().simulationCount.text = roundCounter.ToString();

    }

    static int CountNeighbours(bool[,] cgrid, int x, int y)
    {
        int count = 0;
        for (int i = x-1; i <= x+1; i++)
        {
            for (int j = y-1; j <= y+1; j++)
            {
                if ((i == x && j ==y)  || i < 0 || i >= width || j < 0 || j >= height )
                {
                    continue;
                }

                if (cgrid[i, j])
                {
                    count++;
                }

            }
        }

        return count;
    }
}
